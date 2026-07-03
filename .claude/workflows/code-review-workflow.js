export const meta = {
  name: 'code-review-workflow',
  description:
    'Bulletproof code-review loop: an adversarial reviewer flags issues on a change, a second agent verifies/defends/fixes each one, and the pair re-run until no high-severity issue survives. Returns a hardening brief for the orchestrator to grill interactively.',
  whenToUse:
    'Use to drive a code change to a bulletproof bar. Invoke with args {target, intent, maxRounds}. AFTER it returns, the ORCHESTRATING (main) agent MUST invoke the `grilling` skill on the returned hardening_brief to interrogate the path with the user - grilling is interactive and cannot run inside a background workflow.',
  phases: [
    { title: 'Review', detail: 'adversarial review of the change (requesting-code-review)' },
    { title: 'Resolve', detail: 'verify, defend, and fix each finding (receiving-code-review)' },
    { title: 'Synthesize', detail: 'distill surviving risks into a grilling brief' },
  ],
}

const target =
  (args && args.target) ||
  'the current uncommitted working-tree changes (git diff HEAD, plus untracked files)'
const intent =
  (args && args.intent) ||
  '(not provided - infer the intent from the diff, commit messages, and any linked ticket, and state the intent you inferred)'
const maxRounds = (args && args.maxRounds) || 3

const REVIEW_SCHEMA = {
  type: 'object',
  additionalProperties: false,
  required: ['findings', 'overall'],
  properties: {
    findings: {
      type: 'array',
      items: {
        type: 'object',
        additionalProperties: false,
        required: ['id', 'severity', 'file', 'line', 'summary', 'why', 'suggested_fix'],
        properties: {
          id: { type: 'string' },
          severity: { type: 'string', enum: ['critical', 'high', 'medium', 'low'] },
          file: { type: 'string' },
          line: { type: 'integer' },
          summary: { type: 'string' },
          why: { type: 'string' },
          suggested_fix: { type: 'string' },
        },
      },
    },
    overall: { type: 'string' },
  },
}

const RESOLUTION_SCHEMA = {
  type: 'object',
  additionalProperties: false,
  required: ['resolutions', 'summary'],
  properties: {
    resolutions: {
      type: 'array',
      items: {
        type: 'object',
        additionalProperties: false,
        required: ['id', 'disposition', 'justification', 'files_changed'],
        properties: {
          id: { type: 'string' },
          disposition: { type: 'string', enum: ['fixed', 'refuted', 'deferred'] },
          justification: { type: 'string' },
          files_changed: { type: 'array', items: { type: 'string' } },
        },
      },
    },
    summary: { type: 'string' },
  },
}

const BRIEF_SCHEMA = {
  type: 'object',
  additionalProperties: false,
  required: ['path_summary', 'remaining_risks', 'grilling_questions'],
  properties: {
    path_summary: { type: 'string' },
    remaining_risks: { type: 'array', items: { type: 'string' } },
    grilling_questions: { type: 'array', items: { type: 'string' } },
  },
}

// The review/fix METHODOLOGY lives in the standalone agent defs
// (~/.claude/agents/adversarial-code-reviewer.md and code-review-responder.md)
// so it stays usable from chat too. These prompts carry only the
// workflow-specific context the agents need per round.
function reviewPrompt(round, priorContext) {
  return `Review round ${round}. Review the change adversarially per your role.

WHAT TO REVIEW: ${target}
INTENT THE CHANGE MUST SATISFY: ${intent}

Gather the diff yourself and read the surrounding code before judging. Use finding ids of the form "r${round}-f1", "r${round}-f2", ...
${priorContext}`
}

function fixPrompt(round, findingsJson) {
  return `Resolve these review findings (round ${round}) per your role - verify, defend, or fix each, editing the working tree directly.

INTENT THE CHANGE MUST SATISFY: ${intent}
FINDINGS TO RESOLVE:
${findingsJson}

Return exactly one resolution for every finding id above.`
}

function synthPrompt(historyJson) {
  return `You are preparing a hardening brief so the orchestrator can run an interactive grilling session on this change.

From the full review/resolution history below, produce:
- path_summary: a tight description of what the change does NOW, after the fixes were applied.
- remaining_risks: concrete soft spots that survived the loop - refuted-but-uncertain findings, deferred items, untested paths, and unverified assumptions.
- grilling_questions: the sharpest "what happens when X" / "how do you know Y holds" questions an interrogator should press to make this path bulletproof. Prioritize the highest-leverage unknowns.

HISTORY:
${historyJson}`
}

function buildPriorContext(history) {
  const last = history[history.length - 1]
  const resolutions = last && last.resolution ? last.resolution.resolutions : []
  const refuted = resolutions.filter((r) => r.disposition === 'refuted').map((r) => r.id)
  const fixed = resolutions.filter((r) => r.disposition === 'fixed')
  return `PRIOR ROUND CONTEXT:
- The author already addressed the previous round, so the diff has CHANGED - re-gather it.
- Do NOT re-raise these refuted finding ids unless you have NEW evidence: ${refuted.length ? refuted.join(', ') : '(none)'}
- Confirm these applied fixes are correct and introduced no regressions: ${
    fixed.length
      ? fixed.map((r) => `${r.id} (${r.files_changed.join(', ') || 'see justification'})`).join('; ')
      : '(none)'
  }`
}

const history = []
let converged = false
let round = 0

while (round < maxRounds && !converged) {
  round += 1

  const review = await agent(reviewPrompt(round, round === 1 ? '' : buildPriorContext(history)), {
    label: `review:round-${round}`,
    phase: 'Review',
    agentType: 'adversarial-code-reviewer',
    schema: REVIEW_SCHEMA,
  })
  if (!review) {
    log(`Round ${round}: reviewer produced no result; stopping.`)
    break
  }

  const blocking = review.findings.filter((f) => f.severity === 'critical' || f.severity === 'high')
  log(`Round ${round}: ${review.findings.length} findings (${blocking.length} blocking).`)

  if (blocking.length === 0) {
    history.push({ round, review, resolution: null })
    converged = true
    log(`Round ${round}: no blocking findings - change is at the bulletproof bar.`)
    break
  }

  const resolution = await agent(fixPrompt(round, JSON.stringify(review.findings, null, 2)), {
    label: `resolve:round-${round}`,
    phase: 'Resolve',
    agentType: 'code-review-responder',
    schema: RESOLUTION_SCHEMA,
  })
  history.push({ round, review, resolution })

  const counts = (d) =>
    resolution ? resolution.resolutions.filter((r) => r.disposition === d).length : 0
  log(`Round ${round}: ${counts('fixed')} fixed, ${counts('refuted')} refuted, ${counts('deferred')} deferred.`)
}

if (!converged) {
  log(`Reached maxRounds (${maxRounds}) without full convergence - surfacing residual risk in the brief.`)
}

const brief = await agent(synthPrompt(JSON.stringify(history, null, 2)), {
  label: 'synthesize:hardening-brief',
  phase: 'Synthesize',
  schema: BRIEF_SCHEMA,
})

return {
  rounds: round,
  converged,
  history,
  hardening_brief: brief,
  next_step:
    'ORCHESTRATOR: invoke the `grilling` skill and use hardening_brief.grilling_questions / remaining_risks to interrogate this change with the user. Grilling is interactive and was intentionally left out of this background workflow.',
}
