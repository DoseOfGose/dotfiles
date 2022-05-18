

# Make sure to use the default shell.  E.g. on OSX this is /usr/local/bin/bash
set-option -g default-shell $SHELL

set -g set-titles on
set -g set-titles-string "#S / #W"
set -g mouse on
set -g history-limit 102400
# Start ordering at 1 instead of 0
set -g base-index 1
setw -g pane-base-index 1
# If I have 3 windows open (1, 2, 3) and I close
# window 2, by default 3 would remain "3".  This would
# collapse the empty number by renumbering:
set -g renumber-windows on

setw -g mode-keys vi
bind-key -T copy-mode-vi 'v' send -X begin-selection
bind-key -T copy-mode-vi 'y' send -X copy-selection-and-cancel
# Shorten time after sending esc, otherwise vim
# is a choppy experience
set -g escape-time 0


set-option -g focus-events on

# split panes using | and -
bind | split-window -h
bind - split-window -v
# unbind '"'
# unbind %

# remap prefix from 'C-b' to 'C-a'
# this way I can use C-a for my local tmux, and use default keys on nested remote sessions
unbind C-b
set-option -g prefix C-a
bind-key C-a send-prefix

# Vim keys for navigating panes
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# set-option -g default-command "reattach-to-user-namespace -l bash" # Or '-l zsh'.  Should set this up to know what $shell
bind C-v run "pbpaste | tmux load-buffer - && tmux paste-buffer"
bind C-v run "tmx show-buffer | pbcopy"