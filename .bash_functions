#==============================================================================
function True
{
    true
    echo $?
}
#==============================================================================
function False
{
    false
    echo $?
}
#==============================================================================
function is_installed
{
    app=$1
    which $app
    return $?
}
#==============================================================================
function get_log_date
{
    /bin/date +"%Y.%m.%d %H:%M:%S.%N%Z"
}
#==============================================================================
function __log
{
    level=$1
    shift
    if [[ $1 =~ @single_line_start@ ]]; then
        shift
        printf "%s %s " "$(get_log_date)" "$@"
    elif [[ $1 =~ @single_line_end@ ]]; then
        shift
        echo $@
    else
        echo "$(get_log_date) $level $@"
    fi
}
#==============================================================================
function info
{
    __log INFO $@
}
#==============================================================================
function warn
{
    __log WARNING $@ >&2
}
#==============================================================================
function error
{
    __log ERROR $@ >&2
}
#==============================================================================
function crashburn
{
    local exitcode=$?
    if [ $exitcode -ne 0 ]; then
        exit_with_stack_trace $exitcode $@
    fi
}
#==============================================================================
function exit_with_stack_trace
{
    local exitcode=${1:-UNKNOWN}

    local message="EXECUTON FAILED WITH UNKNOWN EXIT CODE"
    if [[ "$exitcode" = "UNKNOWN" ]]; then
        exitcode=1
    else
        shift  # get rid of the exitcode argument
        if [ $# -eq 0 ]; then
            message="EXECUTON FAILED "
        else
            message="$@ "
        fi
        message="$message[EXIT CODE $exitcode]"
    fi

    error $message
    echo "STACK TRACE:" >&2
    local frame=0
    local stack_elem=$(caller $frame)
    while [ $? -eq 0 ]; do
        echo "    $stack_elem" >&2
        ((++frame))
        stack_elem=$(caller $frame)
    done

    exit $exitcode
}
#==============================================================================
function fatal_error
{
    exit_with_stack_trace 1 $@
}
#==============================================================================
function kill_other_instances
{
    local instance_name=$1
    if [[ -n "$instance_name" ]]; then
        info "own pid: $$"
        for pid in $(/usr/bin/pgrep -f "$instance_name"); do
            if [ $pid -ne $$ ]; then
                warn "killing pid: $pid"
                /bin/kill $pid
            fi
        done
    fi
}
#==============================================================================
