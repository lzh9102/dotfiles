# Disable welcome prompt
set -g fish_greeting

# Keep path components in prompt
set -g fish_prompt_pwd_full_dirs 10

function fish_prompt
	if test $status -eq 0
		set -f prompt_color green
	else
		set -f prompt_color red
	end

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
	echo -n ":"
	echo (prompt_pwd)
  set_color $prompt_color
	echo "└> "
end
