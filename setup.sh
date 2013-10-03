#!/bin/sh

# configuration files without the leading dot
# example: vimrc
FILES="""
vimrc
gvimrc
vim/templates/
vim/bundle/nerdtree/nerdtree_plugin/nerdtree_open.vim
zshrc
gitconfig
hgrc
tmux.conf
pentadactylrc
pentadactyl/colors/
pentadactyl/plugins/
"""

# check for dependencies
require() {
	type $1 > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		echo "ERROR: $1 is required but not installed"
		exit 1
	fi
}
require vim
require git

# post-setup functions
__post_setup_vimrc() {
	mkdir -p ~/.vimswp
	mkdir -p ~/.vim/bundle
	git clone "git://github.com/gmarik/vundle.git" ~/.vim/bundle/vundle
	vim -c 'BundleInstall' -c 'qa!'
}

##############################

BACKUP_DIR=~/dotfiles-old
REPO_DIR=$PWD/`dirname $0`

run_cmd() {
	"$@"
	if [ $? -ne 0 ]; then
		echo "ERROR: $1"
		exit 1
	fi
}

check_cmd_exists() {
	type $1 > /dev/null 2>&1
}

run_post_setup() {
	local function=__post_setup_$1
	if check_cmd_exists $function ; then
		echo "begin post-setup of $1"
		$function
		echo "end post-setup of $1"
	fi
}

backup_original_dotfile() {
	# usage: backup_original_dotfile <filename-without-the-dot>
	# example: backup_original_dotfile vimrc
	local file=~/.$1
	if [ -e $file ]; then
		mkdir -p $BACKUP_DIR/`dirname $1`
		run_cmd cp -Hrp $file $BACKUP_DIR/`dirname $1`
		echo "backup $file to $BACKUP_DIR"
	fi
}

create_symlink() {
	# usage: create_symlink <filename-without-the-dot>
	# see backup_original_dotfile
	local dest=~/.$1
	mkdir -p `dirname $dest`
	rm -f ~/.$1
	run_cmd ln -vsf $REPO_DIR/$1 ~/.$1
}

for file in $FILES; do
	file=`echo $file | sed 's/\/$//g'` # remove trailing slash
	backup_original_dotfile $file
	create_symlink $file
	run_post_setup $file
done
