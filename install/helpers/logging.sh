zero_log_to_stdout() {
  [[ ${ZERO_LOG_TO_STDOUT:-} == "1" || -z ${ZERO_INSTALL_LOG_FILE:-} ]]
}

zero_log_line() {
  if zero_log_to_stdout; then
    echo "$1"
  else
    echo "$1" >>"$ZERO_INSTALL_LOG_FILE"
  fi
}

start_install_log() {
  if ! zero_log_to_stdout; then
    mkdir -p "$(dirname "$ZERO_INSTALL_LOG_FILE")"
    touch "$ZERO_INSTALL_LOG_FILE"
    chmod 666 "$ZERO_INSTALL_LOG_FILE" 2>/dev/null || true
  fi

  export ZERO_START_TIME="${ZERO_START_TIME:-$(date '+%Y-%m-%d %H:%M:%S')}"
  export ZERO_START_EPOCH="${ZERO_START_EPOCH:-$(date +%s)}"

  zero_log_line "=== Zero Setup Started: $ZERO_START_TIME ==="
}

stop_install_log() {
  local end_time end_epoch duration mins secs
  end_time=$(date '+%Y-%m-%d %H:%M:%S')
  end_epoch=$(date +%s)

  zero_log_line "=== Zero Setup Completed: $end_time ==="

  if [[ -n ${ZERO_START_EPOCH:-} ]]; then
    duration=$((end_epoch - ZERO_START_EPOCH))
    mins=$((duration / 60))
    secs=$((duration % 60))
    zero_log_line "Zero setup: ${mins}m ${secs}s"
  fi
}

run_logged() {
  local script="$1"
  local exit_code errexit_was_set=0

  zero_log_line "[$(date '+%Y-%m-%d %H:%M:%S')] Starting: $script"

  case $- in
    *e*)
      errexit_was_set=1
      set +e
      ;;
  esac

  local runner=(bash -eE)
  if [[ ${ZERO_INSTALL_DEBUG:-} == "1" ]]; then
    runner=(bash -x -eE)
  fi

  if zero_log_to_stdout; then
    PS4='+ ${BASH_SOURCE[0]##*/}:${LINENO}:${FUNCNAME[0]:-main}: ' \
      "${runner[@]}" -c 'source "$1"' bash "$script" </dev/null 2>&1
  else
    PS4='+ ${BASH_SOURCE[0]##*/}:${LINENO}:${FUNCNAME[0]:-main}: ' \
      "${runner[@]}" -c 'source "$1"' bash "$script" </dev/null >>"$ZERO_INSTALL_LOG_FILE" 2>&1
  fi

  exit_code=$?
  (( errexit_was_set )) && set -e

  if (( exit_code == 0 )); then
    zero_log_line "[$(date '+%Y-%m-%d %H:%M:%S')] Completed: $script"
  else
    zero_log_line "[$(date '+%Y-%m-%d %H:%M:%S')] Failed: $script (exit code: $exit_code)"
  fi

  return $exit_code
}
