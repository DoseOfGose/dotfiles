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

Collection of doseofgose's personal dotfiles.  See the [Issues tab](https://github.com/DoseOfGose/dotfiles/issues) for planned work to enhance this collection's content and workflows.

## Installation and My Workfile

Dotfiles are quite personal and specific to the individual.  It's recommended to look at the contents as reference/inspiration, but these files are not setup for direct use by the general public.

The [main branch](https://github.com/DoseOfGose/dotfiles/tree/main) of this repository is structured as a GitHub-friendly reference.  File contents and sections can be copied manually, however this repo is intended to be used with a bare repository, as [described here](https://www.atlassian.com/git/tutorials/dotfiles).

## Unique Customizations
### Tmux Git Popup Session
I created a script to utilize a per-session-and-window popup session for quickly triggering various git actions.

To trigger a helpful menu within Tmux, simply do the following key strokes: `C-a`, `C-g`, `?`.  The hotkeys in the menu are equivalent to triggering the actions directly with `C-a`, `C-g`, and then the hotkey.  This utilizes a tmux `key-table` to essentially create a custom "Git Popup Commands" Leader/Layer.

![Screenshot of custom menu](/scripts/tmux-git-menu.png)

See [this example video](https://youtu.be/8QEZ9JOQyoY) for a demo of basic functionality. (Better quality video TBD)


## Current Applications

The following applications have configuration files in this repo:
- Bash
- Vim
- Git
- Tmux
