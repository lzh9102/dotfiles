#!/bin/sh

# fields: os dest [src [perm]]
#   os: output of `uname -o` or * for all os
#   dest: target filename relative to $HOME
#   src: (optional) source filename or url.
#        If <src> is a local file, a symbolic link will be created.
#        If <src> is a url, it will be downloaded and saved as <dest>.
#   perm: (optional) Set permission of <dest> to <perm>.
FILES="""
# files in repository
* .vimrc
* .gvimrc
* .vim/templates/
* .zshrc
* .gitconfig
* .hgrc
* .tmux.conf
* .pentadactylrc
* .pentadactyl/colors/
* .pentadactyl/plugins/
* .screenrc
# system-specific files
GNU/Linux .zsh/zshrc.system zsh/zshrc.gnulinux
FreeBSD   .zsh/zshrc.system zsh/zshrc.freebsd
"""

# non-builtin programs that this script depends on
DEPENDENT_PROGRAMS="git vim"

BACKUP_DIRECTORY=${HOME}/dotfiles-old

# additional steps to do after setup
post_setup() {
	# vim {{{
	# create swap directory
	mkdir -p ${HOME}/.vimswp
	# install vundle
	mkdir -p ${HOME}/.vim/bundle
	local VUNDLE_DIR=${HOME}/.vim/bundle/vundle
	if [ ! -d "$VUNDLE_DIR" ]; then
		git clone "git://github.com/gmarik/vundle.git" "$VUNDLE_DIR"
	else
		echo "INFO: skip installation of vundle because it is already installed"
	fi
	# install plugins defined in vimrc using vundle
	vim -c 'BundleInstall' -c 'qa!'
	# }}}
}

##############################

check_cmd_exists() {
	type $1 > /dev/null 2>&1
}

remove_trailing_slash() {
	sed 's/\/$//'
}

check_dependency() {
	check_cmd_exists
	if [ $? -ne 0 ]; then
		echo "error: $1 is required but not installed"
		exit 1
	fi
}

backup_home_file() {
	echo "backup ${HOME}/$1 to $BACKUP_DIRECTORY/"
	mv "${HOME}/$1" "$BACKUP_DIRECTORY"
	if [ $? -ne 0 ]; then
		echo "error: failed to backup ${HOME}/$1"
		exit 1
	fi
}

create_link() {
	local src=$1
	local dest=$2
	[ -z "$src" ] && src=`echo "$dest" | sed 's/^\.//'`
	ln -svf "`pwd`/$src" "${HOME}/$dest"
}

download_file() {
	local url=$1
	local dest=$2
	echo "downloading $url to ${HOME}/$dest"
	curl -o "${HOME}/$dest" "$url" > /dev/null 2>&1
	[ $? -ne 0 ] && echo "error: failed to download $url" && return 1
	return 0
}

set_permission() {
	chmod -v "$1" "$2" || echo "error: chmod failed: $2"
}

setup_file() {
	local src=$1
	local dest=$2
	local perm=$3
	mkdir -p "${HOME}/`dirname $dest`"
	if echo $src | grep -q '^\(http[s]\?\|ftp\)://'; then # url
		download_file "$src" "$dest"
	else # local file
		create_link "$src" "$dest"
	fi
	[ $? -ne 0 ] && echo "error: failed to setup file $dest"
	[ ! -z "$perm" ] && set_permission "$perm" "${HOME}/$dest"
}

get_field_in_line() {
	echo "$2" | awk "{print \$$1}"
}

##############################

cd `dirname $0`

# check dependencies
for program in $DEPENDENT_PROGRAMS; do
	check_dependency $program
done

# process files
echo "$FILES" | while read line; do
	echo "$line" | grep -q '^[ ]*#' && continue # skip comment
	echo "$line" | grep -q '^[ ]*$' && continue # skip empty line
	os=`get_field_in_line 1 "$line"`
	dest=`get_field_in_line 2 "$line" | remove_trailing_slash`
	src=`get_field_in_line 3 "$line" | remove_trailing_slash`
	perm=`get_field_in_line 4 "$line"`
	[ "$os" != "*" ] && [ "$os" != "`uname -o`" ] && continue # check os
	if [ -e "${HOME}/$dest" ] && [ ! -L "${HOME}/$dest" ]; then
		backup_home_file "$dest" # backup if the file exists and is not a symlink
	fi
	setup_file "$src" "$dest" "$perm"
done

post_setup
