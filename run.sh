#!/bin/bash - 
#===============================================================================
#
#          FILE: run.sh
# 
#         USAGE: ./run.sh 
# 
#   DESCRIPTION: Add entrypoint for qpidd
# 
#       OPTIONS: ---
#        AUTHOR: acefei, acefei@163.com
#       CREATED: 02/11/2020 01:26
#      REVISION:  ---
#===============================================================================

set -e

# Start broker as a daemon and logs to syslog
qpidd --auth=no --trace --daemon

# QPID Broker Configuration for queues exchanges and bindings
while read line ; do
    (echo $line | grep -Eq "^\w+") || continue
    qpid-config $line
done <<EOF 
# Customize config for queues exchanges and bindings
add exchange fanout 
add queue cache.Subscriptions.realtime
bind cache cache.Subscriptions.realtime
EOF

echo -e "\n--- THE INITIAL QUEUES ---"
qpid-config queues
echo -e "\n--- THE INITIAL EXCHANGES ---"
qpid-config exchanges

while :; do qpidd -c >/dev/null; done
