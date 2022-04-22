# Reproduce Vault hang with non-responsive audit socket 

You don't need a socket log server for this demo. 

1. ./audit-setup.sh # configures a file and a socket audit device
1. time vault secrets list # should be fast.
1. ./iptables-drop.sh # drop connections on tcp/1515
1. ./big-kv.sh - fill the audit log buffer? Not sure why this is needed to repro next step.
1. time vault secrets list # should be slow. Vault waits 8s for a server response that never arrives.
1. ./iptables-flush.sh # remove drop rule. 
1. time vault secrets list # should be fast.

