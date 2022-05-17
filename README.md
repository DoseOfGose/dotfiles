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

Initial collection of doseofgose's personal dotfiles.  See the [Issues tab](https://github.com/DoseOfGose/dotfiles/issues) for planned work to enhance this collection's content and workflows.

## Installation

No automated process currently exists.  One method is to clone the repo and copy the files to your home directory by adding a dot `.` prefix:

```bash
git clone https://github.com/DoseOfGose/dotfiles.git
cd dotfiles
cp bashrc ~/.bashrc
cp vimrc ~/.vimrc
cp gitconfig ~/.gitconfig
cp tmux-conf ~/.tmux-conf
```

Working on migrating to use a bare repository with `--work-tree=$HOME` for easy usage, as [seen here](https://www.atlassian.com/git/tutorials/dotfiles).

## Current Applications

The following applications have configuration files in this repo:
- Bash
- Vim
- Git
- Tmux
