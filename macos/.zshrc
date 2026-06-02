# pnpm
export PNPM_HOME="/Users/askonieczny/Library/pnpm"
case ":$PATH:" in
*":$PNPM_HOME/bin:"*) ;;
*) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end

[[ -o interactive && -z "$ZSH_EXECUTION_STRING" ]] || return
exec fish
