# [ ENV-VAR ]
export EDITOR="nvim"

# [ ALIAS ]
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

# [ OH-MY-ZSH ]
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export ZSH="$HOME/.oh-my-zsh"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)
source $ZSH/oh-my-zsh.sh
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
