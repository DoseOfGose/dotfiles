#!/bin/bash

check_if_popup_and_exit_if_it_is() {
  local sessionPrefix="git-popup-"
  local currSession=$(tmux display-message -p '#S')
  if [[ "$currSession" == ${sessionPrefix}* ]]; then
    # Temporary fix - this prevents switching the git-popup to the target project
    # Later I would like this to target the correct client
    exit
  fi
}

# Projects yaml file
projects_yaml="/Users/ericgose/.dotfiles/aux/tmux/projects.yaml"

fzf_preview() {
  local name=$1
  local yaml_path=$2
  yq ".[] | select(.name == \"$name\")" "$yaml_path" | bat -l yaml --color always --style plain
  # local session=$(get_prop_from_yaml "$name" ".session")
  # local window=$(get_prop_from_yaml "$name" ".window")
  # local layout=$(get_prop_from_yaml "$name" ".layout")
  # local path=$(get_prop_from_yaml "$name" ".path")
  # local paneActions="$(get_prop_from_yaml "$name" ".paneActions")"

  # if [ "$layout" = "T" ]; then
    # # Figure out ascii drawing at some point
  # fi
}

export -f fzf_preview

get_user_project_selection() {
  yq '.[].name // ""' "$projects_yaml" \
    | fzf \
    --layout reverse \
    --preview "fzf_preview {..} \"$projects_yaml\""
    # --bind 'j:down,k:up' \
}

get_prop_from_yaml() {
  local project_name=$1
  local prop_expression=$2
  yq ".[] | select(.name == \"$project_name\")" "$projects_yaml" \
    | yq "$prop_expression"
}

export -f get_prop_from_yaml


switch_to_or_create_session_and_window() {
  local path=$1
  local status=$(tmux switch-client -t "$session":"$window" 2>&1 \
    | awk '{print $1" "$2" "$3}')

  local noSession=$([ "${status}" = "can't find session:" ] && echo true)
  local noWindow=$([ "${status}" = "can't find window:" ] && echo true)
  if [ "$noSession" ]; then
    tmux new-session -d -s "$session" -n "$window" -c "$path"
    tmux switch-client -t "$session":"$window"
  elif [ "$noWindow" ]; then
    tmux new-window -a -t "$session" -n "$window" -c "$path"
    tmux switch-client -t "$session":"$window" > /dev/null 2>&1
  else
    echo "already exists"
  fi
}

apply_layout() {
  local layout=$1
  local path=$2

  if [ "$layout" = "T" ]; then
    # T - One pane on top, two panes on bottom
    # ----------
    # |        |
    # |   1    |
    # ----------
    # | 2  | 3 |
    # ----------
    tmux split-window -v -l 20% -t "$session":"$window" -c $path
    tmux split-window -h -l 45% -t "$session":"$window" -c $path
    tmux select-pane -t "$session":"$window".1
  elif [ "$layout" = "side-by-side" ]; then
    # side-by-side - Two panes, one to the left and one to the right
    # ----------
    # |   |    |
    # | 1 | 2  |
    # |   |    |
    # ----------
    tmux split-window -h -l 50% -t "$session":"$window" -c $path
    tmux select-pane -t "$session":"$window".1
  elif [ "$layout" = "=" ]; then
    # = - Two panes, one on top and one on bottom
    # ----------
    # |        |
    # |   1    |
    # ----------
    # |        |
    # |   2    |
    # ----------
    tmux split-window -v -l 20% -t "$session":"$window" -c $path
    tmux select-pane -t "$session":"$window".1
  # elif [ "$layout" = "single-pane"; then
    # single-pane (default) - One pane only
    # ----------
    # |        |
    # |   1    |
    # |        |
    # ----------
    # No need to do anything
  fi

}

apply_actions() {
  local currentAction=1 # I start panes at 1
  while IFS=$'\n' read -r action; do
    tmux send-keys -t "$session":"$window"."$currentAction" "${action#-}" C-m 2>&1
    currentAction=$((currentAction + 1))
  done <<< "$paneActions"
}


project_launch() {
  local name="$1"
  session=$(get_prop_from_yaml "$name" ".session")
  window=$(get_prop_from_yaml "$name" ".window")
  local layout=$(get_prop_from_yaml "$name" ".layout")
  local path=$(get_prop_from_yaml "$name" ".path")
  local paneActions="$(get_prop_from_yaml "$name" ".paneActions")"

  # If session exists, switch to it
  local result=$(switch_to_or_create_session_and_window $path)
  # If it doesn't exist, then apply layout and pane actions
  if [ "$result" != "already exists" ]; then
    apply_layout "$layout" "$path"
    sleep 0.75
    apply_actions "$paneActions"
  fi
}

project_launcher_popup() {
  local script_path=$(cd "$(dirname "$0")"; pwd -P)
  local script_filename=$(basename "$0")
  tmux display-popup -E "'$script_path/$script_filename' project_launcher"
}

project_launcher() {
  local name=$(get_user_project_selection)
  if [ ! "$name" ]; then
    exit
  fi

  project_launch "$name"
}

apply_project_bindings() {
  # Dynamic keybindings from yaml file:
  local num_projects=$(yq 'length' $projects_yaml)
  local script_path=$(cd "$(dirname "$0")"; pwd -P)
  local script_filename=$(basename "$0")

  for i in $(seq 0 $((num_projects - 1)))
  do
    local keybind=$(yq ".[$i].keybind" $projects_yaml)
    if [ "$keybind" = "" ]; then
      continue
    fi
    tmux bind -Tproject-table $keybind run -b "'${script_path}/${script_filename}' quick_launch_binding $keybind"
  done

  # Adhoc binding keys
  for i in q w e r
  do
    tmux bind -Tproject-table $i run -b "'${script_path}/${script_filename}' apply_adhoc_binding C-$i"
  done
}

quick_launch_binding() {
  local hotkey_pressed=$1
  local num_projects=$(yq 'length' $projects_yaml)
  for i in $(seq 0 $((num_projects - 1)))
  do
    local name=$(yq ".[$i].name" $projects_yaml)
    local keybind=$(get_prop_from_yaml "$name" ".keybind")
    if [ "$hotkey_pressed" = "$keybind" ]; then
      project_launch "$name"
      exit
    fi
  done

  tmux display-message "No project on keybind $hotkey_pressed"
}

apply_adhoc_binding() {
  local hotkey=$1
  session=$(tmux display-message -p "#S")
  window=$(tmux display-message -p "#W")

  local script_path=$(cd "$(dirname "$0")"; pwd -P)
  local script_filename=$(basename "$0")
  tmux bind -Tproject-table $keybind switch-client -t "$session":"$window"
}

show_help_menu() {
   $(tmux display-menu -T "#[align=centre fg=green]Custom Projects Menu" \
    "" \
    "-#[nodim align=centre fg=blue]by doseofgose"       ""    "" \
    "-#[nodim align=centre]<TmuxProjectsLeader> is C-p" ""    "" \
    "" \
    "Show Project Select Popup"                         C-l   "" \
    "Jump to project keybind (Keybind)"                 ""    "" \
    "Set current window as jump point (q/w/e/r)"        ""    "" \
    "Go to dynamic jump C-(q/w/e/r)"                    ""    "" \
    "" \
    "Open/Close this help menu"                         ?     "" \
  )
}


main() {
  if (( $# < 1 )); then
    exit 1
  fi

  local cmd
  cmd=$1

  case "$cmd" in
    project_launcher_popup)
      check_if_popup_and_exit_if_it_is
      project_launcher_popup
      ;;
    project_launcher)
      check_if_popup_and_exit_if_it_is
      project_launcher
      ;;
    apply_project_bindings)
      apply_project_bindings
      ;;
    quick_launch_binding)
      check_if_popup_and_exit_if_it_is
      local keybind=$2
      quick_launch_binding $keybind
      ;;
    apply_adhoc_binding)
      local keybind=$2
      apply_adhoc_binding
      ;;
    show_help_menu)
      check_if_popup_and_exit_if_it_is
      show_help_menu
      ;;
    # clear_all_adhoc_bindings)
      # clear_all_adhoc_bindings
    *) echo "Unknown command"
  esac
}

main $@
