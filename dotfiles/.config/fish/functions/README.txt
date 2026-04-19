References:
 * https://github.com/craftzdog/dotfiles-public
 * https://github.com/razzius/fish-functions

================================================================================
Requirements
================================================================================

System packages (macOS / Homebrew):
  - fzf       brew install fzf      # fuzzy finder binary, used by fzf_change_directory

Fish plugins (install via fisher):
  # fisher -- plugin manager (bootstrap)
  curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish \
    | source && fisher install jorgebucaran/fisher

  fisher install PatrickF1/fzf.fish   # fzf widgets + bindings (Ctrl+R history, etc.)
  fisher install jethrokuan/z         # `z` directory frecency, seeds fzf_change_directory
  fisher install edc/bass             # run bash scripts/commands from fish
