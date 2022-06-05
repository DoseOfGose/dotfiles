#!/bin/bash

# Projects yaml file
projects_yaml="$HOME/.dotfiles/aux/tmux/projects.yaml"

fzf_preview() {
  local name=$1
  yq ".[] | select(.name == \"$name\")" projects.yaml
}

export -f fzf_preview

get_user_project_selection() {
  yq '.[].name // ""' "$projects_yaml" \
    | fzf \
    --bind 'j:up,k:down' \
    --preview "fzf_preview {..}"
}

get_prop_from_yaml() {
  local project_name=$1
  local prop_expression=$2
  yq ".[] | select(.name == \"$project_name\")" "$projects_yaml" \
    | yq "$prop_expression"
}

export -f get_prop_from_yaml

switch_to_or_create_session_and_window() {
  local status=$(tmux switch-client -t "$session":"$window" 2>&1 \
    | awk '{print $1" "$2" "$3}')

  local noSession=$([ "${status}" = "can't find session:" ] && echo true)
  local noWindow=$([ "${status}" = "can't find window:" ] && echo true)
  if [ "$noSession" ]; then
    tmux new-session -d -s "$session" -n "$window"
    tmux switch-client -t "$session":"$window" 
  elif [ "$noWindow" ]; then
    tmux new-window -t "$session" -n "$window"
    tmux switch-client -t "$session":"$window" 
  else
    echo "already exists"
  fi
}

apply_layout() {
  local layout=$1

  if [ "$layout" = "T" ]; then
    tmux split-window -v -l 20% -t "$session":"$window"
    tmux split-window -h -l 35% -t "$session":"$window"
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

  echo "$session $window"

  # If session exists, switch to it
  local result=$(switch_to_or_create_session_and_window $path)

  # If it doesn't exist, then apply layout and pane actions
  if [ "$result" != "already exists" ]; then
    apply_layout "$layout"
    sleep 1
    apply_actions "$paneActions"
  fi
}

project_launcher_popup() {
  local name=$(get_user_project_selection)
  if [ ! $name ]; then
    exit
  fi

  project_launch $name
}

apply_project_bindings() {
  local num_projects=$(yq 'length' $projects_yaml)
  local script_path=$(cd "$(dirname "$0")"; pwd -P)
  local script_filename=$(basename "$0")

  for i in $(seq 0 $((num_projects - 1)))
  do
    local keybind=$(yq ".[$i].keybind" $projects_yaml)
    echo $keybind
    tmux bind -Tproject-table $keybind run -b "'${script_path}/${script_filename}' quick_launch_binding $keybind"
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

main() {
  if (( $# < 1 )); then
    exit 1
  fi

  local cmd
  cmd=$1

  case "$cmd" in
    project_launcher_popup)
      project_launcher_popup
      ;;
    apply_project_bindings)
      apply_project_bindings
      ;;
    quick_launch_binding)
      local keybind=$2
      quick_launch_binding $keybind
      ;;
    *) echo "Unknown command"
  esac
}

main $@
