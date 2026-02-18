if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# [ ENV ]
export EDITOR="nvim"

# [] ALIASES ]
alias :q="exit"
alias :c="clear"
alias vim="nvim"
alias pls="sudo"
alias dc="cd"
alias lsa="ls -a"
alias lsl="ls -l"
alias gti="git"
alias mkir="mkdir"
alias cd..="cd .."
alias ssh="kitten ssh"

# [ ZSH-SETTINGS ]
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# [ OH-MY-ZSH ]
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="refined"

plugins=(
  git
  zsh-autosuggestions
  fast-syntax-highlighting
)
source $ZSH/oh-my-zsh.sh

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
