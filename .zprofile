# run brew shellenv in interactive shells, if brew exists
if [[ $- == *i* ]] && [[ -x /opt/homebrew/bin/brew ]]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi
