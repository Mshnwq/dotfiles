y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

yap() {
    local yaziProject="$1"
    shift
    if [ -z "$yaziProject" ]; then
        >&2 echo "ERROR: The first argument must be a project"
        return 64
    fi
    # Generate random Yazi client ID (DDS / `ya emit` uses `YAZI_ID`)
    local yaziId=$RANDOM
    # Use Yazi's DDS to run a plugin command after Yazi has started
    # (the nested subshell is only to suppress "Done" output for the job)
    ( (sleep 0.1; YAZI_ID=$yaziId ya emit plugin projects "load $yaziProject") &)
    # Run Yazi with the generated client ID
    yazi --client-id $yaziId "$@" || return $?
}

yapl() {
    local yaziId=$RANDOM
    ( (sleep 0.1; YAZI_ID=$yaziId ya emit plugin projects "load_last") &)
    # Run Yazi with the generated client ID
    yazi --client-id $yaziId "$@" || return $?
}

#function yapd() {
#    local yaziId=$RANDOM
#    ( (sleep 0.1; YAZI_ID=$yaziId ya emit plugin projects "delete tmux") &)
#    # Run Yazi with the generated client ID
#    yazi --client-id $yaziId "$@" || return $?
#}
