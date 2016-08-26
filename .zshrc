##
# cloudhead - .zshrc
#
[ -f ~/.profile ] && source ~/.profile
[ -f ~/.awsrc ]   && source ~/.awsrc

# `ls` colors
if [ -f ~/.dircolors ]; then
  eval $(dircolors -b ~/.dircolors)
fi

#
# Includes
#
autoload colors && colors
autoload -U compinit && compinit
autoload -U complist

# Fzy integration
if command -v fzy >/dev/null 2>&1 && test -f ~/.fzy.zsh; then
  source ~/.fzy.zsh
else
  bindkey '^R' history-incremental-search-backward
fi

#
# ls
#
LS_IGNORE="Dropbox" # ~/Dropbox is symlinked.

alias ls="/bin/ls -I $LS_IGNORE"
alias l="/bin/ls -lFGhL --color=auto -I $LS_IGNORE"
alias ll='/bin/ls -lFAGh --color=auto'

#
# Aliases
#
alias g='git'
alias mv='/bin/mv -i'
alias ..='cd ..'
alias img='sxiv -a'
alias df='df -h'
alias sys='systemctl'
alias x='startx'
alias web='chromium &'
alias e=$EDITOR
alias pdf='mupdf'
alias webserver='python2 -m SimpleHTTPServer'
alias pacman='sudo pacman --color=auto'
alias vim=nvim

#
# History
#
HISTFILE=~/.zsh_history
HISTSIZE=4096
SAVEHIST=4096
REPORTTIME=10

setopt NO_BG_NICE
setopt NO_HUP
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS
setopt LOCAL_TRAPS
setopt EXTENDED_HISTORY
setopt PROMPT_SUBST
setopt CORRECT
setopt COMPLETE_IN_WORD
setopt NO_IGNORE_EOF
setopt AUTO_CD
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_DUPS
setopt INTERACTIVECOMMENTS

#
# Set prompt
#
precmd() {
  local last=$?
  local remote=""

  if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    remote=" $(whoami)@$(hostname)"
  fi

  # Status
  if [ "$last" -eq 0 ]; then
    PROMPT='; '
    RPROMPT="$remote"
  else
    PROMPT="%{$fg[red]%}; %{$reset_color%}"
    RPROMPT=" $last"
  fi

  if [ "$RPROMPT" != "" ]; then
    RPROMPT="%{$fg[red]%}#$RPROMPT%{$reset_color%}"
  fi
}

#
# Vi-mode
#
set -o vi
#
zle-keymap-select zle-line-init() {
  # Check ~/.st/config.h for the cursor escape sequences.
  case $KEYMAP in
    vicmd)      print -n -- "\e[2 q";;
    viins|main) print -n -- "\e[4 q";;
  esac

  zle reset-prompt
  zle -R
}

zle-line-finish() {
  print -n -- "\e[2 q"
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select

col() {
  awk "{ print \$$1 }"
}

#
# Switch to `fg` process with Ctrl-Z
#
fg-command() {
  if [[ ! $#BUFFER -eq 0 ]]; then
    zle push-input
  fi
  BUFFER="fg"
  zle accept-line
}
zle -N fg-command
bindkey '^Z' fg-command

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
