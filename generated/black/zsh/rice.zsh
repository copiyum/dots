# macOS rice managed Zsh config.
# Source this from ~/.zshrc after reviewing it, or use it as the basis for a full ~/.zshrc.

if [[ "${TERM_PROGRAM:-}" == "iTerm.app" || "${TERM_PROGRAM:-}" == "iTerm2" ]]; then
  if [[ -x /Applications/iTerm.app/Contents/Resources/it2profile ]]; then
    /Applications/iTerm.app/Contents/Resources/it2profile -s "macOS Rice Black" >/dev/null 2>&1 || true
  else
    printf '\033]1337;SetProfile=macOS Rice Black\a'
  fi
fi

if [[ -o interactive && -z "${RICE_KOTOFETCH_SHOWN:-}" ]] && command -v kotofetch >/dev/null 2>&1; then
  export RICE_KOTOFETCH_SHOWN=1
  kotofetch
fi

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

[[ -f "$HOME/.secrets.zsh" ]] && source "$HOME/.secrets.zsh"

fpath=("$HOME/.zsh/completions" $fpath)
autoload -Uz compinit
compinit

if [[ -f "$HOME/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh" ]]; then
  source "$HOME/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh"
fi

export ZSH="${ZSH:-$HOME/.oh-my-zsh}"
COMPLETION_WAITING_DOTS="true"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

if [[ -f "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
fi

export NVM_DIR="$HOME/.nvm"
[[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]] && source "/opt/homebrew/opt/nvm/nvm.sh"
[[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ]] && source "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

export PATH="$PATH:$HOME/.lmstudio/bin"
export PATH="/opt/homebrew/opt/openjdk@25/bin:$PATH"
export JAVA_HOME="/opt/homebrew/opt/openjdk@25/libexec/openjdk.jdk/Contents/Home"

[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export PATH="$PATH:$HOME/.local/bin"
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"
export PATH="$PATH:$HOME/go/bin"
export PATH="/Library/TeX/texbin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

[[ "$TERM_PROGRAM" == "kiro" ]] && source "$(kiro --locate-shell-integration-path zsh)"
[[ "$TERM_PROGRAM" == "vscode" ]] && source "$(code --locate-shell-integration-path zsh)"

export LITTLE_CODER_BASH_ALLOW="npm,npx,gh,ssh-add,curl,find,grep,rg"
export OPENCODE_ENABLE_EXA=1

[[ -f "$HOME/.fzf.zsh" ]] && source "$HOME/.fzf.zsh"

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh --cmd cd)"
fi

if command -v navi >/dev/null 2>&1; then
  eval "$(navi widget zsh)"
fi

alias pi-minimax='little-coder --provider anthropic --model MiniMax-M2.7'
alias trailmark="uvx --python 3.12 trailmark"
alias yy='yazi'
alias cat='bat --paging=never'
alias ls='eza'
alias ll='eza -la'
alias lt='eza --tree'
alias grep='rg'
alias whois='wtfis'
alias godmode='claude --dangerously-skip-permissions'

function y() {
  local tmp
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat "$tmp")" && [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
    cd "$cwd"
  fi
  rm -f "$tmp"
}

zstyle ':completion:*' menu no
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --tree --level=2 --color=always $realpath'
zstyle ':fzf-tab:complete:(cat|bat):*' fzf-preview 'bat --color=always $realpath'

export POSH_THEME="$HOME/.config/oh-my-posh/rice-black.omp.json"
if command -v oh-my-posh >/dev/null 2>&1 && [[ -f "$POSH_THEME" ]]; then
  eval "$(oh-my-posh init zsh --config "$POSH_THEME")"
fi

if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh --disable-up-arrow)"
  if (( $+widgets[self-atuin-ai-question-mark] )); then
    bindkey -M emacs '?' self-atuin-ai-question-mark
    bindkey -M viins '?' self-atuin-ai-question-mark
  fi
fi
