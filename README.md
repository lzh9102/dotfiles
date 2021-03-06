lzh9102's dot files
===================

Configuration files for common programs I use.

Setup
-----

Warning: This script takes no effort to backup existing files in the home
directory. Please make sure that you do want to overwrite those files before
running this script.

Run the following command in your terminal. The setup script depends on `vim`
and `git`, so please make sure you have them in your system.

```bash
git clone git://github.com/lzh9102/dotfiles ~/dotfiles  # ~/dotfiles can be any directory
cd ~/dotfiles
./setup.sh
```

Be sure to change the git and mercurial username after installation.

Features
--------

### vim
- use vundle to manage plugins
- automatically install all plugins in the setup script
- compatible with neovim

### zsh
- two-line prompt
- source `~/.zshrc.local` at the end of `~/.zshrc` for system-specific settings
