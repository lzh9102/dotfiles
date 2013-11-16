#!/bin/sh

# fields: os dest [src [perm]]
#   os: output of `uname -o` or * for all os
#   dest: target filename relative to $HOME
#   src: (optional) source filename or <id>.
#        If *src* is a local file, a symbolic link will be created.
#        If *src* is an id surrounded by angle brackets (<id>), $URLS will be
#        searched to lookup the actual url and compare the checksum if
#        provided.
#   perm: (optional) Set permission of *dest* to *perm*.
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
# urls
* .bin/ack <ack> 755
"""

# fields: id url sha1
#   id: a unique identifier consists of alphabets, dots and underscore
#   url: the mapped url
#   sha1: (optional) the sha1 checksum of the downloaded file
URLS="""
ack http://beyondgrep.com/ack-2.10-single-file 6052cee5a4f580006fb9135e46411c5322c24a2a
"""

# non-builtin programs that this script depends on
DEPENDENT_PROGRAMS="git vim curl"

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
	[ ! -e "${HOME}/$1" ] && return 0
	local parent_dir="`dirname "$BACKUP_DIRECTORY/$1"`"
	echo "backup ${HOME}/$1 to $parent_dir/$1"
	mkdir -p "$parent_dir"
	cp -ar "${HOME}/$1" "$parent_dir"
	if [ $? -ne 0 ]; then
		echo "error: failed to backup ${HOME}/$1"
		exit 1
	fi
}

create_link() {
	local src=$1
	local dest=$2
	[ -z "$src" ] && src=`echo "$dest" | sed 's/^\.//'`
	[ -L "${HOME}/$dest" ] && rm -f "${HOME}/$dest" # remove original link
	ln -svf "`pwd`/$src" "${HOME}/$dest"
}

check_sha1sum() {
	local dest_path=$1
	local sha1=$2
	echo "checking sha1 sum of $dest_path"
	[ "`compute_sha1 $dest_path`" == "$sha1" ]
}

download_file() {
	local url=$1
	local dest=$2
	local sha1=$3
	local dest_path="${HOME}/$dest"
	if [ -f "$dest_path" ] && check_sha1sum "$dest_path" "$sha1"; then
		echo "checksum ok, use existing file: $dest_path"
		return 0;
	fi
	echo "downloading $url to $dest_path"
	curl -o "$dest_path" "$url" > /dev/null 2>&1
	[ $? -ne 0 ] && echo "error: failed to download $url" && return 1
	if [ ! -z "$sha1" ]; then # check sha1
		check_sha1sum "$dest_path" $sha1
		if [ $? -ne 0 ]; then
			echo "error: $dest_path: sha1 sum mismatch. The file will be deleted."
			rm -f "$dest_path"
			return 1
		fi
	fi
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
	if is_download "$src"; then
		local id="`echo "$src" | sed -e 's/^<//g' -e 's/>$//g'`"
		local url_line="`echo "$URLS" | grep "^$id "`"
		local sha1="`get_field_in_line 3 "$url_line"`"
		src=`get_field_in_line 2 "$url_line"`
		if [ -f "${HOME}/$dest" ]; then # backup file if checksum mismatch
			check_sha1sum "${HOME}/$dest" "$sha1"
			[ $? -ne 0 ] && backup_home_file "$dest"
		fi
		download_file "$src" "$dest" "$sha1"
	else # local file
		# backup if the file exists and is not a symlink
		[ ! -L "${HOME}/$dest" ] && backup_home_file "$dest"
		create_link "$src" "$dest"
	fi
	[ $? -ne 0 ] && echo "error: failed to setup file $dest" && return 1
	[ ! -z "$perm" ] && set_permission "$perm" "${HOME}/$dest"
}

get_field_in_line() {
	echo "$2" | awk "{print \$$1}"
}

is_download() {
	echo $1 | grep -q '^<.*>$'
}

compute_sha1() {
	local SHA1=
	check_cmd_exists sha1 && SHA1=sha1
	[ -z "$SHA1" ] && check_cmd_exists sha1sum && SHA1=sha1sum
	[ -z "$SHA1" ] && echo "error: sha1 program not found" && return 1
	cat $1 | $SHA1 | awk '{print $1}'
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
	setup_file "$src" "$dest" "$perm"
done

post_setup
