lzh9102 dot files
=================

These are the configuration files for common programs I use:

- [vim](http://www.vim.org/)
- [zsh](http://www.zsh.org/)
- [pentadactyl](http://5digits.org/pentadactyl/)
- [tmux](http://tmux.sourceforge.net/)
- [git](http://git-scm.com/)
- [mercurial](http://mercurial.selenic.com/)

Setup
-----

Run the following command in your terminal. Existing configuration files will
be copied to `~/dotfiles-old/`. The setup script depends on `vim` and `git`, so
please make sure you install them before running the script.

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
- swap files are written to `~/.vimswp/`

### zsh
- display current time in right prompt
- source `~/.zshrc-local` at the end of `~/.zshrc` for system-specific settings
- I am not using *oh-my-zsh*; you can add it if you like it.
