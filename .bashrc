# Bash customizations

# Add custom scripts folder locations to PATH
export PATH="/opt/homebrew/bin/:~/Code/System/Scripts:~/go/bin:/usr/local/bin:$PATH"

# Use vi keybindings instead of emacs style
set -o vi

# Reload bash -- useful for when trying out new customizations
alias reload_bashrc='source ~/.bashrc'

# Helper commands for using worktree setup for dotfiles on local system
# First is for my active files
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
# Second is for the presentation version for GitHub
alias dotfiles-github='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME/Code/System/dotfiles'

# Grep with color
alias grep='grep --color'
alias _grep='/usr/bin/grep'

# ls file flags 
alias ls='ls -FG'
alias _ls='/bin/ls'

# Command to load file w/ SSH connections:
alias load_ssh='source ~/.ssh-list'

# Customize terminal prefix
# PS1 Colors:
# Eventually want to be able to set colorscheme in 1 file that gets
# applied to PS/terminal/vim/tmux
# These are roughly mapped from current adhoc color scheme
PS_COLOR() {
  echo '\[\e[38;5;'"${1}"'m\]'
}
PS_GREEN="$(PS_COLOR 115)"
PS_OTHER_GREEN="$(PS_COLOR 151)"
PS_LAVENDER="$(PS_COLOR 147)"
PS_GRAY="$(PS_COLOR 59)"
PS_BLUE="$(PS_COLOR 111)"
PS_ORANGE="$(PS_COLOR 223)"
PS_RED="$(PS_COLOR 181)"
PS_COLOR_RESET="\[\e[0m\]"
PS_PREFIX_LINE_ONE='╭─'
PS_PREFIX_LINE_TWO='╰─'
PS2_PREFIX='  ┇';
PS_PROMPT_SYMBOL=$'\uf7d8'
PS1_GIT=''
PS1="${PS_OTHER_GREEN}${PS_PREFIX_LINE_ONE}${PS_GREEN}\u ${PS_GRAY}at ${PS_BLUE}\h ${PS_GRAY}in ${PS_ORANGE}\W ${PS_GRAY}(${PS_LAVENDER}\@${PS_GRAY}) ${PS_RED}\${PS1_GIT}\n${PS_OTHER_GREEN}${PS_PREFIX_LINE_TWO}${PS_PROMPT_SYMBOL} ${PS_COLOR_RESET}"
PS2="${PS_GREEN}${PS2_PREFIX} ${PS_COLOR_RESET}"

prompt_command() {
  # $? is 0 if git dir, otherwise false
  if git status > /dev/null 2>&1; then
    # Yay, overengineering:
    local DYNAMIC_FIELDS_USED="\u \h \W"
    local STATIC_LENGTH=22
    local FIELD_LENGTH=$(echo ${DYNAMIC_FIELDS_USED@P} | wc -c)
    local TERM_LENGTH=$(tput cols)
    local AVAIL_CHARS=$(expr $TERM_LENGTH - $FIELD_LENGTH - $STATIC_LENGTH)
    local GIT_STATUS_FULL=$(git status | grep 'On branch' | cut -b 11-)
    local GIT_STATUS_FULL_LENGTH=$(echo $GIT_STATUS_FULL | wc -c)
    local GIT_STATUS
    if [ "$GIT_STATUS_FULL_LENGTH" -gt "$AVAIL_CHARS" ]; then
      AVAIL_CHARS=$(expr $AVAIL_CHARS - 3)
    fi
    if [ "$AVAIL_CHARS" -lt 1 ]; then
      # TODO: figure out some better handling here - this is just to prevent status going to 2x lines
      export PS1_GIT=" "$'\ue725'"*"
    else
      GIT_STATUS=$(echo $GIT_STATUS_FULL | sed 's/\(.\{'"$AVAIL_CHARS"'\}\).*/\1.../')
      export PS1_GIT=" "$'\ue725'" ${GIT_STATUS}"
    fi
  else
    export PS1_GIT=""
  fi

}
PROMPT_COMMAND=prompt_command
# Go up directory
alias ..='cd ..'
# alias --='cd -' # -- doesn't appear to be legal bash
# More readable df output
alias df='df -bH'
alias _df='/bin/df'
# Adjust cd to show first 3 ls lines on directory change
# alias cd='pwd && builtin cd "$@" && ls'
alias _cd='/usr/bin/cd'
function cd() {
  builtin cd "$@" && echo -e "\x1b[1mNow in:\x1b[0m `pwd`" && ls
}
# Make pwd check if directory is a symlink or not, and if so show where it is linking to
alias pwd='/bin/pwd; if [ `/bin/pwd` != `/bin/pwd -P` ]; then   echo -e "\x1b[45mSymLink To:\x1b[0m `/bin/pwd -P`"; fi'
alias _pwd='/bin/pwd'


# IP Helpers
# Get my external internet IP
alias myip-internet='curl http://ipecho.net/plain; echo'
function myip-intranet() {
  ifconfig en0 | grep 'inet ' | awk '{print $2}'
}


# History Changes
# Set `history` to append history to file
shopt -s histappend
# Increase history size from default 500
export HISTSIZE=5000
# Also increase the history file size
export HISTFILESIZE=5000
# Set history to ignore consecutive duplicate commands and commands that start with a space
export HISTCONTROL=ignoreboth
alias _history='command history'
_clean_history() {
  # history -n has to be there before history -w to read from
  # .bash_history the commands saved from any other terminal,
  _history -n            # Read in entries that are not in current history
  _history -w            # Write history, trigger erasedups
  #history -a            # Append history; does not trigger erasedups
  _history -c            # Clear current history
  _history -r            # Read history from $HISTFILE
}
# This can really mess with history expansion, e.g. `!!`.
# But if you don't use history expansion, good way to constantly sync history:
# Add history+grep shorthand
function history() {
  _clean_history
  if [[ $# -eq 0 ]];
  then
    command history
  else
    command history | grep $1
  fi
}

# NVM Setup
export NVM_DIR=~/.nvm
# Followig line is set in MacOS section -- need to find generic setup for Linux
# source $(brew --prefix nvm)/nvm.sh


#   extract:  Extract most know archives with one command
#   ---------------------------------------------------------
    extract () {
        if [ -f $1 ] ; then
          case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
             esac
         else
             echo "'$1' is not a valid file"
         fi
    }

alias vim=nvim
alias vi=nvim
alias neovim=nvim

export EDITOR=nvim
export VISUAL=nvim

# Some dev helper aliases/functions.  Git aliases are handled by gitconfig
singlejest() {
  node node_modules/jest/bin/jest.js -i "$1" -c jest.config.js 
}

if [[ "$OSTYPE" == "darwin"* ]]; then
  export BASH_SILENCE_DEPRECATION_WARNING=1

# Autocomplete for brew applications:
export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# nvm setup utilizing brew:
source $(brew --prefix nvm)/nvm.sh

#   cdf:  'cd to directory of frontmost window of MacOS Finder
    cdf () {
        currFolderPath=$( /usr/bin/osascript <<EOT
            tell application "Finder"
                try
            set currFolder to (folder of the front window as alias)
                on error
            set currFolder to (path to desktop folder as alias)
                end try
                POSIX path of currFolder
            end tell
EOT
        )
        echo "cd to \"$currFolderPath\""
        cd "$currFolderPath"
    }

fi

# fzf auto-complete and bindings
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
