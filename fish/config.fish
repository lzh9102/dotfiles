set -g fish_greeting  # Disable welcome prompt

function fish_prompt
	if test $status -eq 0
		set -f prompt_color green
	else
		set -f prompt_color red
	end

	set_color --bold
	set_color $prompt_color
	echo -n "🐟"
	set_color cyan
	echo -n (whoami)
	set_color green
	echo -n "@"
	set_color magenta
	echo -n (hostname -s)
	set_color $prompt_color
	echo -n ":"
	echo (pwd)
	echo "└> "
end
