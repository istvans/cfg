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
function get_log_date
{
    /bin/date +"%Y.%m.%d %H:%M:%S.%N%Z"
}
#==============================================================================
function log
{
    dt=$(get_log_date)
    echo "$dt $@"
}
#==============================================================================
function crashburn
{
    exitcode=$?
    if [ $exitcode -ne 0 ]; then
        local line=$(caller | cut -f1 -d' ')
        ((line -= 1))
        log "EXECUTION FAILED ON LINE: $line! [EXIT CODE: $exitcode]"
        exit $exitcode
    fi
}
#==============================================================================
function kill_other_instances
{
    if [[ -n "$VPNMON_INSTANCE_NAME" ]]; then
        log "own pid: $$"
        for pid in $(/usr/bin/pgrep -f "$VPNMON_INSTANCE_NAME"); do
            if [ $pid -ne $$ ]; then
                log "killing pid: $pid"
                /bin/kill $pid
            fi
        done
    fi
}
#==============================================================================
