#!/bin/bash
# Claude Code status line: model | cwd | git branch | context remaining (tokens + %) | effort | thinking | fast mode | session/week/cost usage | lines of diff

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name')
dir=$(basename "$(echo "$input" | jq -r '.workspace.current_dir')")

branch=""
if git --no-optional-locks rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch=$(git --no-optional-locks branch --show-current 2>/dev/null)
  if [ -z "$branch" ]; then
    branch=$(git --no-optional-locks rev-parse --short HEAD 2>/dev/null)
  fi
fi

remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
used_tokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
ctx_size=$(echo "$input" | jq -r '.context_window.context_window_size // empty')

# Format a raw token count as e.g. 120k
format_tokens() {
  awk -v n="$1" 'BEGIN { printf "%dk", (n + 500) / 1000 }'
}

ctx_str=""
if [ -n "$remaining" ] && [ -n "$used_tokens" ] && [ -n "$ctx_size" ]; then
  ctx_str="$(format_tokens "$used_tokens")/$(format_tokens "$ctx_size") (${remaining}% left)"
elif [ -n "$remaining" ]; then
  ctx_str="${remaining}% left"
fi

session_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
session_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
week_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')
now=$(date +%s)

# Format seconds-until-reset with the two largest units, e.g. 5d11h or 2h0m
format_remaining() {
  awk -v s="$1" 'BEGIN {
    if (s < 0) s = 0
    d = int(s / 86400); h = int((s % 86400) / 3600); m = int((s % 3600) / 60)
    if (d > 0) printf "%dd%dh", d, h
    else if (h > 0) printf "%dh%dm", h, m
    else printf "%dm", m
  }'
}
cost_usd=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')
lines_added=$(echo "$input" | jq -r '.cost.total_lines_added // empty')
lines_removed=$(echo "$input" | jq -r '.cost.total_lines_removed // empty')

effort=$(echo "$input" | jq -r '.effort.level // empty')
thinking=$(echo "$input" | jq -r 'if .thinking.enabled == true then "on" elif .thinking.enabled == false then "off" else empty end')
fast_mode=$(echo "$input" | jq -r 'if .fast_mode == true then "on" elif .fast_mode == false then "off" else empty end')

# ANSI colors (dimmed for terminal status line)
COLOR_MODEL="\033[2;36m"   # dim cyan
COLOR_DIR="\033[2;34m"     # dim blue
COLOR_BRANCH="\033[2;33m"  # dim yellow
COLOR_CTX="\033[2;32m"     # dim green
COLOR_USAGE="\033[2;35m"   # dim magenta
COLOR_META="\033[2;90m"    # dim gray
RESET="\033[0m"
SEP="\033[2;37m|${RESET}"

line1_parts=()
line1_parts+=("${COLOR_MODEL}${model}${RESET}")
line1_parts+=("${COLOR_DIR}${dir}${RESET}")
if [ -n "$branch" ]; then
  line1_parts+=("${COLOR_BRANCH}${branch}${RESET}")
fi
if [ -n "$ctx_str" ]; then
  line1_parts+=("${COLOR_CTX}${ctx_str}${RESET}")
fi
if [ -n "$effort" ]; then
  line1_parts+=("${COLOR_META}effort: ${effort}${RESET}")
fi
if [ -n "$thinking" ]; then
  line1_parts+=("${COLOR_META}think: ${thinking}${RESET}")
fi
if [ -n "$fast_mode" ]; then
  line1_parts+=("${COLOR_META}fast: ${fast_mode}${RESET}")
fi

line2_parts=()
if [ -n "$session_pct" ]; then
  session_str="5h: $(printf '%.0f' "$session_pct")%"
  if [ -n "$session_reset" ]; then
    session_str+=" $(format_remaining "$((session_reset - now))")"
  fi
  line2_parts+=("${COLOR_USAGE}${session_str}${RESET}")
fi
if [ -n "$week_pct" ]; then
  week_str="7d: $(printf '%.0f' "$week_pct")%"
  if [ -n "$week_reset" ]; then
    week_str+=" $(format_remaining "$((week_reset - now))")"
  fi
  line2_parts+=("${COLOR_USAGE}${week_str}${RESET}")
fi
if [ -n "$cost_usd" ] && awk -v c="$cost_usd" 'BEGIN { exit !(c + 0 >= 0.005) }'; then
  line2_parts+=("${COLOR_USAGE}\$$(printf '%.2f' "$cost_usd")${RESET}")
fi

line3_parts=()
added=${lines_added:-0}
removed=${lines_removed:-0}
if [ $((added + removed)) -gt 0 ]; then
  line3_parts+=("${COLOR_CTX}diff: +${added} -${removed} ($((added + removed)) lines)${RESET}")
fi

join_parts() {
  local out="" i
  for i in "$@"; do
    if [ -n "$out" ]; then
      out+=" ${SEP} "
    fi
    out+="$i"
  done
  printf '%s' "$out"
}

printf "%b\n" "$(join_parts "${line1_parts[@]}")"
if [ "${#line2_parts[@]}" -gt 0 ]; then
  printf "%b\n" "$(join_parts "${line2_parts[@]}")"
fi
if [ "${#line3_parts[@]}" -gt 0 ]; then
  printf "%b\n" "$(join_parts "${line3_parts[@]}")"
fi
