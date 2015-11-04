#!/bin/sh
# Download all vim vundle plugins defined in ~/.vimrc in parallel

BUNDLE_DIR="${HOME}/.vim/bundle"

# install vundle
mkdir -p "$BUNDLE_DIR"
if [ ! -d "$BUNDLE_DIR" ]; then
	git clone 'https://github.com/VundleVim/Vundle.vim' "$BUNDLE_DIR/Vundle.vim"
fi

# extract plugins from ~/.vimrc
PLUGINS="`sed -n 's/^[ \t]*\(Plugin\|Bundle\) \(.*\)$/\2/p' "${HOME}/.vimrc"`"
PLUGINS_COUNT="`echo "$PLUGINS" | wc -l`"
echo "INFO: $PLUGINS_COUNT plugin(s) defined in ~/.vimrc"

# download plugins
for plugin in $PLUGINS; do
	# skip vim comments
	if echo "$plugin" | grep -q '^"'; then
		continue
	fi

	# strip surrounding quotes
	plugin="`echo $plugin | grep -o '[a-zA-Z0-9_.\-]\+\(/[a-zA-Z0-9_.\-]\+\)\?'`"

	# convert plugin string to github url
	if echo "$plugin" | grep -q '/'; then
		# format 1: the plugin string contains a slash (/):
		# username/project ==> https://github.com/{username/project}.git
		url=https://github.com/${plugin}.git
		plugin_name="`echo "$plugin" | sed -n 's/^.*\///p'`" # strip username
	else
		# format 2: project ==> https://github.com/vim-scripts/{project}.git
		url=https://github.com/vim-scripts/${plugin}.git
		plugin_name="$plugin"
	fi

	# download the plugin if it doesn't exist
	# TODO: download to tmp and copy to $BUNDLE_DIR
	if [ ! -d "${BUNDLE_DIR}/${plugin_name}" ]; then
		git clone "$url" "${BUNDLE_DIR}/${plugin_name}" &
	fi
done

# wait for all downloads to finish
wait
