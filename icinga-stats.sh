#!/bin/bash

contains() {
    [[ $1 =~ (^|[[:space:]])$2($|[[:space:]]) ]] && return 0 || return 1
}

ITEM=$1

ITEMKEYS='total_hsts
total_srvs
cmd_buffers_used
cmd_buffers_high
cmd_buffers_total
external_cmds_last_1min
external_cmds_last_5min
external_cmds_last_15min
act_hsts_last_1min
act_hsts_last_5min
act_hsts_last_15min
act_hsts_last_60min
psv_hsts_last_1min
psv_hsts_last_5min
psv_hsts_last_15min
psv_hsts_last_60min
act_hst_checks_last_1min
act_hst_checks_last_5min
act_hst_checks_last_15min
psv_hst_checks_last_1min
psv_hst_checks_last_5min
psv_hst_checks_last_15min
act_srvs_last_1min
act_srvs_last_5min
act_srvs_last_15min
act_srvs_last_60min
psv_srvs_last_1min
psv_srvs_last_5min
psv_srvs_last_15min
psv_srvs_last_60min
act_srv_checks_last_1min
act_srv_checks_last_5min
act_srv_checks_last_15min
psv_srv_checks_last_1min
psv_srv_checks_last_5min
psv_srv_checks_last_15min
total_hst_state_change_min
total_hst_state_change_max
total_hst_state_change_ave
act_hst_state_change_min
act_hst_state_change_max
act_hst_state_change_ave
psv_hst_state_change_min
psv_hst_state_change_max
psv_hst_state_change_ave
total_srv_state_change_min
total_srv_state_change_max
total_srv_state_change_ave
act_srv_state_change_min
act_srv_state_change_max
act_srv_state_change_ave
psv_srv_state_change_min
psv_srv_state_change_max
psv_srv_state_change_ave
act_hst_latency_min
act_hst_latency_max
act_hst_latency_ave
psv_hst_latency_min
psv_hst_latency_max
psv_hst_latency_ave
act_hst_exec_time_min
act_hst_exec_time_max
act_hst_exec_time_ave
act_srv_latency_min
act_srv_latency_max
act_srv_latency_ave
psv_srv_latency_min
psv_srv_latency_max
psv_srv_latency_ave
act_srv_exec_time_min
act_srv_exec_time_max
act_srv_exec_time_ave'

# item keys
if [ -z $1 ]; then

    echo "Supported items"
    for item in $ITEMKEYS
    do
        echo $item
    done
    exit 1

fi

if [[ $ITEMKEYS != *"$ITEM"* ]]; then
  echo "'$ITEM' is not a supported item" >&2
  exit 1
fi


ICINGASTATS_CMD=`which icingastats`
RC=$?
if [ $RC -ne 0 ]; then
  echo "icingastats not found" >&2
  exit 1
fi
ICINGASTATS=`$ICINGASTATS_CMD`
RC=$?
if [ $RC -ne 0 ]; then
  echo "icingastats failed" >&2
  exit 1
fi

# Total
total_hsts=`echo "$ICINGASTATS" | grep "^Total Hosts:" | awk '{print $3}'`
total_srvs=`echo "$ICINGASTATS" | grep "^Total Services:" | awk '{print $3}'`

# Command Buffers
cmd_buffers_used=`echo "$ICINGASTATS" | grep "^Used/High/Total Command Buffers:" \
                  | perl -pe "s|.*(\d+) / \d+ / \d+|\1|"`
cmd_buffers_high=`echo "$ICINGASTATS" | grep "^Used/High/Total Command Buffers:" \
                  | perl -pe "s|.*\d+ / (\d+) / \d+|\1|"`
cmd_buffers_total=`echo "$ICINGASTATS" | grep "^Used/High/Total Command Buffers:" \
                  | perl -pe "s|.*\d+ / \d+ / (\d+)|\1|"`

# External Commands
external_cmds_last_1min=`echo "$ICINGASTATS" | grep "^External Commands Last 1/5/15 min:" \
                         | perl -pe "s|.*(\d+) / \d+ / \d+|\1|"`
external_cmds_last_5min=`echo "$ICINGASTATS" | grep "^External Commands Last 1/5/15 min:" \
                         | perl -pe "s|.*\d+ / (\d+) / \d+|\1|"`
external_cmds_last_15min=`echo "$ICINGASTATS" | grep "^External Commands Last 1/5/15 min:" \
                          | perl -pe "s|.*\d+ / \d+ / (\d+)|\1|"`

# Active Host
act_hsts_last_1min=`echo "$ICINGASTATS" | grep "^Active Hosts Last 1/5/15/60 min:" \
                    | perl -pe "s|.*(\d+) / \d+ / \d+ / \d+|\1|"`
act_hsts_last_5min=`echo "$ICINGASTATS" | grep "^Active Hosts Last 1/5/15/60 min:" \
                    | perl -pe "s|.*\d+ / (\d+) / \d+ / \d+|\1|"`
act_hsts_last_15min=`echo "$ICINGASTATS" | grep "^Active Hosts Last 1/5/15/60 min:" \
                     | perl -pe "s|.*\d+ / \d+ / (\d+) / \d+|\1|"`
act_hsts_last_60min=`echo "$ICINGASTATS" | grep "^Active Hosts Last 1/5/15/60 min:" \
                     | perl -pe "s|.*\d+ / \d+ / \d+ / (\d+)|\1|"`

# Passive Host
psv_hsts_last_1min=`echo "$ICINGASTATS" | grep "^Passive Hosts Last 1/5/15/60 min:" \
                    | perl -pe "s|.*(\d+) / \d+ / \d+ / \d+|\1|"`
psv_hsts_last_5min=`echo "$ICINGASTATS" | grep "^Passive Hosts Last 1/5/15/60 min:" \
                    | perl -pe "s|.*\d+ / (\d+) / \d+ / \d+|\1|"`
psv_hsts_last_15min=`echo "$ICINGASTATS" | grep "^Passive Hosts Last 1/5/15/60 min:" \
                     | perl -pe "s|.*\d+ / \d+ / (\d+) / \d+|\1|"`
psv_hsts_last_60min=`echo "$ICINGASTATS" | grep "^Passive Hosts Last 1/5/15/60 min:" \
                     | perl -pe "s|.*\d+ / \d+ / \d+ / (\d+)|\1|"`

# Active Host Checks
act_hst_checks_last_1min=`echo "$ICINGASTATS" | grep "^Active Host Checks Last 1/5/15 min:" \
                          | perl -pe "s|.*(\d+) / \d+ / \d+|\1|"`
act_hst_checks_last_5min=`echo "$ICINGASTATS" | grep "^Active Host Checks Last 1/5/15 min:" \
                          | perl -pe "s|.*\d+ / (\d+) / \d+|\1|"`
act_hst_checks_last_15min=`echo "$ICINGASTATS" | grep "^Active Host Checks Last 1/5/15 min:" \
                          | perl -pe "s|.*\d+ / \d+ / (\d+)|\1|"`

# Passive Host Checks
psv_hst_checks_last_1min=`echo "$ICINGASTATS" | grep "^Passive Host Checks Last 1/5/15 min:" \
                          | perl -pe "s|.*(\d+) / \d+ / \d+|\1|"`
psv_hst_checks_last_5min=`echo "$ICINGASTATS" | grep "^Passive Host Checks Last 1/5/15 min:" \
                          | perl -pe "s|.*\d+ / (\d+) / \d+|\1|"`
psv_hst_checks_last_15min=`echo "$ICINGASTATS" | grep "^Passive Host Checks Last 1/5/15 min:" \
                          | perl -pe "s|.*\d+ / \d+ / (\d+)|\1|"`

# Active Service
act_srvs_last_1min=`echo "$ICINGASTATS" | grep "^Active Services Last 1/5/15/60 min:" \
                    | perl -pe "s|.*(\d+) / \d+ / \d+ / \d+|\1|"`
act_srvs_last_5min=`echo "$ICINGASTATS" | grep "^Active Services Last 1/5/15/60 min:" \
                    | perl -pe "s|.*\d+ / (\d+) / \d+ / \d+|\1|"`
act_srvs_last_15min=`echo "$ICINGASTATS" | grep "^Active Services Last 1/5/15/60 min:" \
                     | perl -pe "s|.*\d+ / \d+ / (\d+) / \d+|\1|"`
act_srvs_last_60min=`echo "$ICINGASTATS" | grep "^Active Services Last 1/5/15/60 min:" \
                     | perl -pe "s|.*\d+ / \d+ / \d+ / (\d+)|\1|"`

# Passive Service
psv_srvs_last_1min=`echo "$ICINGASTATS" | grep "^Passive Services Last 1/5/15/60 min:" \
                    | perl -pe "s|.*(\d+) / \d+ / \d+ / \d+|\1|"`
psv_srvs_last_5min=`echo "$ICINGASTATS" | grep "^Passive Services Last 1/5/15/60 min:" \
                    | perl -pe "s|.*\d+ / (\d+) / \d+ / \d+|\1|"`
psv_srvs_last_15min=`echo "$ICINGASTATS" | grep "^Passive Services Last 1/5/15/60 min:" \
                     | perl -pe "s|.*\d+ / \d+ / (\d+) / \d+|\1|"`
psv_srvs_last_60min=`echo "$ICINGASTATS" | grep "^Passive Services Last 1/5/15/60 min:" \
                     | perl -pe "s|.*\d+ / \d+ / \d+ / (\d+)|\1|"`

# Active Service Checks
act_srv_checks_last_1min=`echo "$ICINGASTATS" | grep "^Active Service Checks Last 1/5/15 min:" \
                          | perl -pe "s|.*(\d+) / \d+ / \d+|\1|"`
act_srv_checks_last_5min=`echo "$ICINGASTATS" | grep "^Active Service Checks Last 1/5/15 min:" \
                          | perl -pe "s|.*\d+ / (\d+) / \d+|\1|"`
act_srv_checks_last_15min=`echo "$ICINGASTATS" | grep "^Active Service Checks Last 1/5/15 min:" \
                          | perl -pe "s|.*\d+ / \d+ / (\d+)|\1|"`

# Passive Service Checks
psv_srv_checks_last_1min=`echo "$ICINGASTATS" | grep "^Passive Service Checks Last 1/5/15 min:" \
                          | perl -pe "s|.*(\d+) / \d+ / \d+|\1|"`
psv_srv_checks_last_5min=`echo "$ICINGASTATS" | grep "^Passive Service Checks Last 1/5/15 min:" \
                          | perl -pe "s|.*\d+ / (\d+) / \d+|\1|"`
psv_srv_checks_last_15min=`echo "$ICINGASTATS" | grep "^Passive Service Checks Last 1/5/15 min:" \
                          | perl -pe "s|.*\d+ / \d+ / (\d+)|\1|"`

# Total Host State Change
total_hst_state_change_min=`echo "$ICINGASTATS" | grep "^Total Host State Change:" \
                          | perl -pe "s|.*(\d+\.\d+) / \d+\.\d+ / \d+\.\d+ .*|\1|"`
total_hst_state_change_max=`echo "$ICINGASTATS" | grep "^Total Host State Change:" \
                          | perl -pe "s|.*\d+\.\d+ / (\d+\.\d+) / \d+\.\d+ .*|\1|"`
total_hst_state_change_ave=`echo "$ICINGASTATS" | grep "^Total Host State Change:" \
                          | perl -pe "s|.*\d+\.\d+ / \d+\.\d+ / (\d+\.\d+) .*|\1|"`

# Active Host State Change
act_hst_state_change_min=`echo "$ICINGASTATS" | grep "^Active Host State Change:" \
                          | perl -pe "s|.*(\d+\.\d+) / \d+\.\d+ / \d+\.\d+ .*|\1|"`
act_hst_state_change_max=`echo "$ICINGASTATS" | grep "^Active Host State Change:" \
                          | perl -pe "s|.*\d+\.\d+ / (\d+\.\d+) / \d+\.\d+ .*|\1|"`
act_hst_state_change_ave=`echo "$ICINGASTATS" | grep "^Active Host State Change:" \
                          | perl -pe "s|.*\d+\.\d+ / \d+\.\d+ / (\d+\.\d+) .*|\1|"`

# Passive Host State Change
psv_hst_state_change_min=`echo "$ICINGASTATS" | grep "^Passive Host State Change:" \
                          | perl -pe "s|.*(\d+\.\d+) / \d+\.\d+ / \d+\.\d+ .*|\1|"`
psv_hst_state_change_max=`echo "$ICINGASTATS" | grep "^Passive Host State Change:" \
                          | perl -pe "s|.*\d+\.\d+ / (\d+\.\d+) / \d+\.\d+ .*|\1|"`
psv_hst_state_change_ave=`echo "$ICINGASTATS" | grep "^Passive Host State Change:" \
                          | perl -pe "s|.*\d+\.\d+ / \d+\.\d+ / (\d+\.\d+) .*|\1|"`

# Total Service State Change
total_srv_state_change_min=`echo "$ICINGASTATS" | grep "^Total Service State Change:" \
                          | perl -pe "s|.*(\d+\.\d+) / \d+\.\d+ / \d+\.\d+ .*|\1|"`
total_srv_state_change_max=`echo "$ICINGASTATS" | grep "^Total Service State Change:" \
                          | perl -pe "s|.*\d+\.\d+ / (\d+\.\d+) / \d+\.\d+ .*|\1|"`
total_srv_state_change_ave=`echo "$ICINGASTATS" | grep "^Total Service State Change:" \
                          | perl -pe "s|.*\d+\.\d+ / \d+\.\d+ / (\d+\.\d+) .*|\1|"`

# Active Service State Change
act_srv_state_change_min=`echo "$ICINGASTATS" | grep "^Active Service State Change:" \
                          | perl -pe "s|.*(\d+\.\d+) / \d+\.\d+ / \d+\.\d+ .*|\1|"`
act_srv_state_change_max=`echo "$ICINGASTATS" | grep "^Active Service State Change:" \
                          | perl -pe "s|.*\d+\.\d+ / (\d+\.\d+) / \d+\.\d+ .*|\1|"`
act_srv_state_change_ave=`echo "$ICINGASTATS" | grep "^Active Service State Change:" \
                          | perl -pe "s|.*\d+\.\d+ / \d+\.\d+ / (\d+\.\d+) .*|\1|"`

# Passive Service State Change
psv_srv_state_change_min=`echo "$ICINGASTATS" | grep "^Passive Service State Change:" \
                          | perl -pe "s|.*(\d+\.\d+) / \d+\.\d+ / \d+\.\d+ .*|\1|"`
psv_srv_state_change_max=`echo "$ICINGASTATS" | grep "^Passive Service State Change:" \
                          | perl -pe "s|.*\d+\.\d+ / (\d+\.\d+) / \d+\.\d+ .*|\1|"`
psv_srv_state_change_ave=`echo "$ICINGASTATS" | grep "^Passive Service State Change:" \
                          | perl -pe "s|.*\d+\.\d+ / \d+\.\d+ / (\d+\.\d+) .*|\1|"`

# Active Host Latency
act_hst_latency_min=`echo "$ICINGASTATS" | grep "^Active Host Latency:" \
                     | perl -pe "s|.*(\d+\.\d+) / \d+\.\d+ / \d+\.\d+ .*|\1|"`
act_hst_latency_max=`echo "$ICINGASTATS" | grep "^Active Host Latency:" \
                     | perl -pe "s|.*\d+\.\d+ / (\d+\.\d+) / \d+\.\d+ .*|\1|"`
act_hst_latency_ave=`echo "$ICINGASTATS" | grep "^Active Host Latency:" \
                     | perl -pe "s|.*\d+\.\d+ / \d+\.\d+ / (\d+\.\d+) .*|\1|"`

# Passive Host Latency
psv_hst_latency_min=`echo "$ICINGASTATS" | grep "^Passive Host Latency:" \
                     | perl -pe "s|.*(\d+\.\d+) / \d+\.\d+ / \d+\.\d+ .*|\1|"`
psv_hst_latency_max=`echo "$ICINGASTATS" | grep "^Passive Host Latency:" \
                     | perl -pe "s|.*\d+\.\d+ / (\d+\.\d+) / \d+\.\d+ .*|\1|"`
psv_hst_latency_ave=`echo "$ICINGASTATS" | grep "^Passive Host Latency:" \
                     | perl -pe "s|.*\d+\.\d+ / \d+\.\d+ / (\d+\.\d+) .*|\1|"`

# Active Host Execution Time
act_hst_exec_time_min=`echo "$ICINGASTATS" | grep "^Active Host Execution Time:" \
                       | perl -pe "s|.*(\d+\.\d+) / \d+\.\d+ / \d+\.\d+ .*|\1|"`
act_hst_exec_time_max=`echo "$ICINGASTATS" | grep "^Active Host Execution Time:" \
                       | perl -pe "s|.*\d+\.\d+ / (\d+\.\d+) / \d+\.\d+ .*|\1|"`
act_hst_exec_time_ave=`echo "$ICINGASTATS" | grep "^Active Host Execution Time:" \
                       | perl -pe "s|.*\d+\.\d+ / \d+\.\d+ / (\d+\.\d+) .*|\1|"`

#Active Service Latency
act_srv_latency_min=`echo "$ICINGASTATS" | grep "^Active Service Latency:" \
                     | perl -pe "s|.*(\d+\.\d+) / \d+\.\d+ / \d+\.\d+ .*|\1|"`
act_srv_latency_max=`echo "$ICINGASTATS" | grep "^Active Service Latency:" \
                     | perl -pe "s|.*\d+\.\d+ / (\d+\.\d+) / \d+\.\d+ .*|\1|"`
act_srv_latency_ave=`echo "$ICINGASTATS" | grep "^Active Service Latency:" \
                     | perl -pe "s|.*\d+\.\d+ / \d+\.\d+ / (\d+\.\d+) .*|\1|"`

# Passive Service Latency
psv_srv_latency_min=`echo "$ICINGASTATS" | grep "^Passive Service Latency:" \
                     | perl -pe "s|.*(\d+\.\d+) / \d+\.\d+ / \d+\.\d+ .*|\1|"`
psv_srv_latency_max=`echo "$ICINGASTATS" | grep "^Passive Service Latency:" \
                     | perl -pe "s|.*\d+\.\d+ / (\d+\.\d+) / \d+\.\d+ .*|\1|"`
psv_srv_latency_ave=`echo "$ICINGASTATS" | grep "^Passive Service Latency:" \
                     | perl -pe "s|.*\d+\.\d+ / \d+\.\d+ / (\d+\.\d+) .*|\1|"`

# Active Service Execution Time
act_srv_exec_time_min=`echo "$ICINGASTATS" | grep "^Active Service Execution Time:" \
                       | perl -pe "s|.*(\d+\.\d+) / \d+\.\d+ / \d+\.\d+ .*|\1|"`
act_srv_exec_time_max=`echo "$ICINGASTATS" | grep "^Active Service Execution Time:" \
                       | perl -pe "s|.*\d+\.\d+ / (\d+\.\d+) / \d+\.\d+ .*|\1|"`
act_srv_exec_time_ave=`echo "$ICINGASTATS" | grep "^Active Service Execution Time:" \
                       | perl -pe "s|.*\d+\.\d+ / \d+\.\d+ / (\d+\.\d+) .*|\1|"`

echo ${!ITEM}
exit 0
