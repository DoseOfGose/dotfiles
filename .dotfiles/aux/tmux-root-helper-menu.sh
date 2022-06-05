#!/bin/bash


# I want this command to be in the .conf file, but it's a massive string to manage.  Look into migrating later:
show_root_help_menu() {
   $(tmux display-menu -T "#[align=centre fg=green]Custom Tmux Help Menu" \
    "" \
    "-#[nodim fg=blue]Prefix and Leaders"          ""       "" \
    "-<Prefix> is C-a (Default C-b)"          ""       "" \
    "-<GitPopupLeader> is C-g"          ""       "" \
    "-#[nodim fg=blue]Session"          ""       "" \
    "-#[nodim fg=blue]Session"          ""       "" \
    "Rename current session" $         "command-prompt -I rename-session" \
    "Create new session"     ""     "command-prompt -I new-session" \
    "Kill session"     ""     "command-prompt -I kill-session" \
    "List/select sessions"     s     "command-prompt -I select-session" \
    "-#[nodim fg=blue]Window"          ""       "" \
    "Rename current window" ","         "command-prompt -I rename-window" \
    "Create new window"     "c"     "command-prompt -I new-window" \
    "Kill window"     "&"     "command-prompt -I kill-window" \
    "List/select windows"     s     "command-prompt -I select-window" \
    "-#[nodim fg=blue]Pane"          ""       "" \
    "-#[nodim]Focus Pane [hjkl] or [0-9]"          ""       "" \
    "Show Pane Numbers Overlay" q "command-prompt -I display-panes" \
    "Kill pane"     x     "command-prompt -I kill-pane" \
    "Add vertical split --" "\"" "command-prompt -I \"split -v\"" \
    "Add horizontal split |" % "command-prompt -I \"split -h\"" \
    "Toggle pane full terminal zoom" z "command-prompt -I \"display-message 'Unsure about the command for this'\"" \
    "Focus next pane" o "command-prompt -I \"display-message 'Unsure about the command for this'\"" \
    "Rotate panes in layout" C-o "command-prompt -I \"display-message 'Unsure about the command for this'\"" \
    "Move pane left" "{" "command-prompt -I \"display-message 'Unsure about the command for this'\"" \
    "Move pane right" "}" "command-prompt -I \"display-message 'Unsure about the command for this'\"" \
    "Toggle between layouts" " " "command-prompt -I \"display-message 'Unsure about the command for this'\"" \
    "-#[nodim fg=blue]Misc"          ""       "" \
    "Detach"                         d         "command-prompt -I detach" \
    "Big Clock"                         t         "command-prompt -I clock-mode" \
    "Command-Prompt"                         :         "command-prompt" \
    "Default ? Menu" "" "command-prompt -I list-keys" \
    "Show Help Menu Help Menu" "" "run -b '\"$0\" show_help_menu_help_menu'" \
    "Show Git Popup Help Menu <GitPopupLeader>?" "" "run -b '\"$HOME/.dotfiles/aux/tmux-test-git.sh\" show_help_menu'" \
  )
}

show_vanity_menu() {
  $(tmux display-menu -T "#[align=centre fg=green]Vanity/Info Menu" \
    "" \
    "-#[nodim align=centre fg=blue]by doseofgose" "" "" \
    "" \
    "-Marker: humboldt" "" "" \
  )
}

show_help_menu_help_menu () { # lol
  $(tmux display-menu -T "#[align=centre fg=green]Help Menu Help Menu" \
    "Show Vanity/Info Menu" "" "run -b '\"$0\" show_vanity_menu'" \
    "" \
    "-#[fg=blue]Tmux Help Menu (This One)" "" "" \
    "-<Prefix> is C-a" "" "" \
    "-Re-Source Conf is <Prefix><GitPopupLeader>S" "" "" \
    "-Help Menu is <Prefix>?" "" "" \
    "" \
    "-#[fg=blue]Neovim Help Menu" "" "" \
    "-<Leader> is Space" "" "" \
    "-Help Menu is <Leader>?" "" "" \
  )
}

main() {
  if (( $# < 1 )); then
    show_root_help_menu
    return
  fi

  local cmd
  cmd=$1

  case "$cmd" in
    show_help_menu_help_menu)
      show_help_menu_help_menu
      ;;
    show_vanity_menu)
      show_vanity_menu
      ;;
    *) echo "Unknown command"
  esac
}

main $@
