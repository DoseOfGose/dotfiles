#!/bin/bash
# This script is intended to only be called by tmux keybindings in .tmux.conf (or other source files)
# The intent of this script is to setup the behavior to have advanced control over various commands to:
# 1. Open a popup and attach/create a persistent session
#   a. If issued from the target session, this is ignored
# 2. Optionally pass a parameter that corresponds to a specific command to be sent to the session, e.g. "status" => `git status`
# Within tmux kindings, this lets me setup an easy to use layer (via key-table) to quickly handle various git commands

session_name=$(tmux display-message -p "#S")
window_name=$(tmux display-message -p "#W")
pane_path=$(tmux display-message -p "#{pane_current_path}")
# Using git command to allow for alternate git commands e.g. for bare repos
git=git
git_dot_option="."
# Change this to whatever prefix you want your git popup sessions to be prefixed with
# E.g. The session ends up being PREFIX-SESSION-WINDOW
# Since killing sessions is based on matching this prefix, it should be unique and not used for other unrelated sessions
session_prefix="git-popup-"

open_popup_if_not_git_session() {
  local command
  local new_sesh
  local pause_for_launch
  command="$1"
  new_sesh="${session_prefix}${session_name}-${window_name}"
  
  if [[ ! "$session_name" == ${session_prefix}* ]]; then
    pause_for_launch="true"
    local session_path
    session_path="$(project_dir_lookup)"
    tmux display-popup -E "tmux new-session -A -s \"${new_sesh}\" -c ${session_path}" &
  fi

  if [[ ! -z $command ]]; then
    if [[ ! -z $pause_for_launch ]]; then
      sleep 0.25
    fi
    tmux send-keys "$command" C-m > /dev/null 2>&1
  fi
}

kill_all_git_sessions() {
  tmux ls | awk -F':' '/^'"${session_prefix}"'.*/ {print $1}' | while read line; do
    kill_git_session "$line"
  done

}

kill_git_session() {
  local session_to_kill
  local session_param
  session_param="$1"

  if [[ "$session_param" == ${session_prefix}* ]]; then
    session_to_kill="$session_param"
  else
    session_to_kill="${session_prefix}${session_name}-${window_name}"
  fi
  tmux kill-session -t "$session_to_kill"
}

project_dir_lookup() {
  case "$session_name" in
    idonate)
      case "$window_name" in
        giving-form)
          echo '~/Code/iDonate/giving-form'
          ;;
        gms-react)
          echo '~/Code/iDonate/gms-react'
          ;;
        idonate-backend)
          echo '~/Code/iDonate/idonate-backend'
          ;;
        *)
          echo '~/Code/iDonate'
          ;;
      esac
      ;;
    config)
      case "$window_name" in
        *)
          echo '~/.dotfiles'
          ;;
      esac
      ;;
    *) echo "$pane_path"
  esac
}

toggle_popup() {
  if [[ "$session_name" == ${session_prefix}* ]]; then
    tmux detach-client
  else
    open_popup_if_not_git_session
  fi
}

# I want this command to be in the .conf file, but it's a massive string to manage.  Look into migrating later:
show_help_menu() {
   $(tmux display-menu -T "#[align=centre fg=green]Custom Git Menu" \
    "" \
    "-#[nodim align=centre fg=blue]by doseofgose" "" "" \
    "-#[nodim align=centre]<GitPopupLeader> is C-g" "" "" \
    "" \
    "Toggle Git Popup for this Session+Window"          C-g       "run -b '\"$0\" toggle_popup'" \
    "Exit from Popup"                                   C-Escape  "run -b '\"$0\" exit_popup'" \
    "Kill this Session+Window's Git Popup (No Prompt!)" x         "run -b '\"$0\" kill_current_git_session" \
    "Kill ALL Git Popups (No Prompt!)"                  X         "run -b '\"$0\" kill_all_git_sessions'" \
    "" \
    "Git Status"                                        C-s       "run -b '\"$0\" git_status'" \
    "Git Add"                                           a         "run -b '\"$0\" git_add'" \
    "Git Add Interactively"                             A         "run -b '\"$0\" git_add_interactive'" \
    "Git Custom lg"                                     C-l       "run -b '\"$0\" git_lg'" \
    "Git Custom lga"                                    l         "run -b '\"$0\" git_lga'" \
    "Git Pull"                                          p         "run -b '\"$0\" git_pull'" \
    "Git Push"                                          P         "run -b '\"$0\" git_push'" \
    "Git Commit"                                        c         "run -b '\"$0\" git_commit'" \
    "" \
    "Yarn (Install)"                                    i         "run -b '\"$0\" git_yarn_install'" \
    "Yarn Test"                                         t         "run -b '\"$0\" git_yarn_test'" \
    "" \
    "Open/Close this help menu"                         ?         "" \
  )
}

main() {
  if (( $# < 1 )); then
    exit 1
  fi

  local cmd
  cmd=$1

  if [[ $session_name == config || $session_name == ${session_prefix}config-* ]]; then
    git=dotfiles
    git_dot_option="-u"
  fi

  case "$cmd" in
    popup_only)
      open_popup_if_not_git_session
      ;;
    git_status)
      open_popup_if_not_git_session "$git status"
      ;;
    git_add)
      open_popup_if_not_git_session "$git add $git_dot_option"
      ;;
    git_add_interactive)
      open_popup_if_not_git_session "$git add -i"
      ;;
    git_lg)
      open_popup_if_not_git_session "$git lg"
      ;;
    git_lga)
      open_popup_if_not_git_session "$git lga"
      ;;
    git_push)
      open_popup_if_not_git_session "$git push"
      ;;
    git_pull)
      open_popup_if_not_git_session "$git pull"
      ;;
    git_commit)
      open_popup_if_not_git_session "$git commit"
      ;;
    git_yarn_install)
      open_popup_if_not_git_session "yarn"
      ;;
    git_yarn_test)
      open_popup_if_not_git_session "yarn test"
      ;;
    toggle_popup)
      toggle_popup
      ;;
    kill_current_git_session)
      kill_git_session "$session_name"
      ;;
    kill_all_git_sessions)
      kill_all_git_sessions
      ;;
    show_help_menu)
      show_help_menu
      ;;
    exit_popup)
      if [[ "$session_name" == ${session_prefix}* ]]; then
        tmux detach-client
      fi
      ;;
    *) echo "Unknown command"
  esac
}

main $@
