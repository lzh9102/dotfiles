set -g fish_greeting  # Disable welcome prompt

function fish_prompt
	set_color --bold
	set_color green
	echo -n "🐟"
	set_color cyan
	echo -n (whoami)
	set_color green
	echo -n "@"
	set_color magenta
	echo -n (hostname -s)
	set_color green
	echo (pwd)
	echo "└> "
end
