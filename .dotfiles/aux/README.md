```text
  __          __       ___      ___                    
 /\ \        /\ \__  /'___\ __ /\_ \                   
 \_\ \    ___\ \ ,_\/\ \__//\_\\//\ \      __    ____  
 /'_` \  / __`\ \ \/\ \ ,__\/\ \ \ \ \   /'__`\ /',__\ 
/\ \L\ \/\ \L\ \ \ \_\ \ \_/\ \ \ \_\ \_/\  __//\__, `\
\ \___,_\ \____/\ \__\\ \_\  \ \_\/\____\ \____\/\____/
 \/__,_ /\/___/  \/__/ \/_/   \/_/\/____/\/____/\/___/ 
                               doseofgose's collection 
```

# dotfiles

A _Work in Progress_ ™️.

Collection of doseofgose's personal dotfiles.

## Current Applications

The following applications have configuration files and related scripts in this repo:
- Bash
- Vim
- Git
- Tmux
- Alacritty

## Installation and My Workfile

Dotfiles are quite personal and specific to the individual.  It's recommended to look at the contents as reference/inspiration, but these files are not setup for direct use by the general public.

The [main branch](https://github.com/DoseOfGose/dotfiles/tree/main) of this repository is structured as a GitHub-friendly reference.  File contents and sections can be copied manually, however this repo is intended to be used with a bare repository using the `active` branch, as [described here](https://www.atlassian.com/git/tutorials/dotfiles).

## Prerequisites

Most requirements/prerequisites are not captured here.  I will try to add more over time.

## Unique Customizations
### Tmux Git Popup Session
I created a script to utilize a per-session-and-window popup session for quickly triggering various git actions.

To trigger a helpful menu within Tmux, simply do the following key strokes: `C-a`, `C-g`, `?`.  The hotkeys in the menu are equivalent to triggering the actions directly with `C-a`, `C-g`, and then the hotkey.  This utilizes a tmux `key-table` to essentially create a custom "Git Popup Commands" Leader/Layer.

![Screenshot of custom menu](/scripts/tmux-git-menu.png)

See [this example video](https://youtu.be/8QEZ9JOQyoY) for a demo of basic functionality. (I'll make a better quality video "eventually")

## Work In Progress
I make changes when I have the motivation, desire, and time.  These tend to come in short burts, sometimes with many months in between.  With so many, many things I want to do with my setup, this means these dotfiles are just a snapshot of a work in progress.  In a way, dotfiles are a continuous project -- one that is never really complete.
