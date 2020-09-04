#!/bin/sh
# install dotfiles to home directory

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
* .vimrc vim/vimrc
* .gvimrc vim/gvimrc
* .vim/templates/
* .vim/after/ftplugin vim/filetypes
* .zshrc zsh/zshrc
* .gitconfig
* .tigrc
* .hgrc
* .tmux.conf
* .octaverc
* .cgdb/cgdbrc cgdbrc
* .config/feh/ feh/
* .Xmodmap
# system-specific files
GNU/Linux .zsh/zshrc.system zsh/zshrc.gnulinux
FreeBSD   .zsh/zshrc.system zsh/zshrc.freebsd
Cygwin    .zsh/zshrc.system zsh/zshrc.cygwin
# urls
* .bin/ack                       <ack>              755
* .bin/cloc                      <cloc>             755
* .bin/interactive-rename        <imv>              755
* .bin/makegen                   <mkgen>            755
* .vim/autoload/plug.vim         <vim-plug>
"""

# fields: id url sha1
#   id: a unique identifier consists of alphabets, dots and underscore
#   url: the mapped url
#   sha1: (optional) the sha1 checksum of the downloaded file
URLS="""
ack http://beyondgrep.com/ack-2.14-single-file 49c43603420521e18659ce3c50778a4894dd4a5f
cloc https://github.com/AlDanial/cloc/raw/86c075779d1178ac2e8948963860dcda16e83636/cloc 9db7c77d5d85fee1dbf24e006483004ea0119225
imv https://raw.github.com/lzh9102/interactive-rename/master/interactive-rename.py 58ad196a6a2b6ba6fea92ccc046684cbaddf3794
mkgen https://raw.github.com/lzh9102/makegen/master/makegen.py 9cfa060b6beba4b575c8beb981b73c5d6498bbed
vim-plug https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"""

# non-builtin programs that this script depends on
DEPENDENT_PROGRAMS="git vim"

# additional steps to do after setup
post_setup() {
	# vim {{{
	# create swap and backup directories
	mkdir -p ${HOME}/.vim/swap
	mkdir -p ${HOME}/.vim/backup

	# install vim plugins
	if [ -f ~/.vim/autoload/plug.vim ]; then
		vim -c "PlugInstall" -c "qa"
	else
		echo "vim-plug cannot be found; skip plugin installation"
	fi

	# tmux {{{
	# apply patch if tmux version < 2.4 and tmux.conf is unmodified
	if check_cmd_exists 'tmux'; then
		tmux_version=`tmux -V | awk '{print $2}' | sed 's/\./0/g'`
		if [ $tmux_version -lt 204 ] && ! git_file_modified 'tmux.conf'; then
			patch < _patches/tmux-before-v2.4.diff
		fi
	fi
	# }}}
}

##############################

relpath() { # compute relative path for $1 with respect to $2
	perl -e 'use File::Spec; print File::Spec->abs2rel(@ARGV) . "\n"' $1 $2 \
		2>/dev/null
}

check_cmd_exists() {
	type $1 > /dev/null 2>&1
}

git_file_modified() {
	[ `git status --short "$1" | wc -l` -eq 1 ]
}

remove_trailing_slash() {
	sed 's/\/$//'
}

check_dependency() {
	check_cmd_exists "$1"
	if [ $? -ne 0 ]; then
		echo "error: $1 is required but not installed"
		exit 1
	fi
}

create_link() {
	local src=$1
	local dest=$2
	[ -z "$src" ] && src=`echo "$dest" | sed 's/^\.//'`
	# convert to absolute path
	src="`pwd`/$src"
	# exit on error if $src exists
	if [ ! -e "$src" ]; then
		echo "error: source file doesn't exist: $src"
		return 1
	fi

	dest="${HOME}/$dest"
	dest_dir="`dirname "$dest"`"

	# convert src to path relative to destination dir (NOTE: "relpath" may fail)
	src_relative="`relpath "$src" "$dest_dir"`"
	[ $? -eq 0 ] && src="$src_relative" # only apply if "relpath" succeeded

	# remove original link
	[ -L "$dest" ] && rm -f "$dest"
	# create link from $dest to $src
	ln -svf "$src" "$dest"
}

check_sha1sum() {
	local dest_path=$1
	local sha1=$2
	test "`compute_sha1 $dest_path`" = "$sha1"
}

call_downloader() {
	local url=$1
	local dest=$2
	if check_cmd_exists wget; then
		wget -O "$dest" "$url" > /dev/null 2>&1
		return $?
	elif check_cmd_exists curl; then
		curl -L -o "$dest" "$url" > /dev/null 2>&1
		return $?
	fi
	echo "error: curl or wget not found"
	return 1 # no downloader available
}

download_file() {
	local url=$1
	local dest=$2
	local sha1=$3
	local dest_path="${HOME}/$dest"
	if [ -f "$dest_path" ] && check_sha1sum "$dest_path" "$sha1"; then
		echo "checksum matches, use existing file: $dest_path"
		return 0;
	fi
	echo "downloading $url"
	call_downloader "$url" "${dest_path}.tmp"
	if [ $? -ne 0 ]; then # download failed
		echo "error: failed to download $url"
		rm -f "${dest_path}.tmp"
		return 1
	fi
	if [ ! -z "$sha1" ]; then # check sha1
		check_sha1sum "${dest_path}.tmp" "$sha1"
		if [ $? -ne 0 ]; then
			echo "error: ${dest_path}.tmp: sha1 sum mismatch. The file will be deleted."
			rm -f "${dest_path}.tmp"
			return 1
		fi
	fi
	mv "${dest_path}.tmp" "${dest_path}"
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
		download_file "$src" "$dest" "$sha1"
	else # local file
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
	line="`echo "$line" | sed 's/#.*$//'`"      # strip comments
	echo "$line" | grep -q '^[ ]*$' && continue # skip empty line
	os=`get_field_in_line 1 "$line"`
	dest=`get_field_in_line 2 "$line" | remove_trailing_slash`
	src=`get_field_in_line 3 "$line" | remove_trailing_slash`
	perm=`get_field_in_line 4 "$line"`
	[ "$os" != "*" ] && [ "$os" != "`uname -o`" ] && continue # check os
	setup_file "$src" "$dest" "$perm"
done

post_setup
