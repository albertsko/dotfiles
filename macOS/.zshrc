if [[ -o interactive ]] && [[ -t 0 ]] && [[ -t 1 ]] && [[ -t 2 ]] && [[ ${TERM:-dumb} != dumb ]] && command -v fish >/dev/null 2>&1; then
	exec fish
fi
