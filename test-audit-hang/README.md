# Vault hangs with non-responsive audit socket

Vault will skip non-functioning audit device as long as it can successfully log the audit message to one audit device. 

Assuming the customer has a working file audit device configured and a socket device of varying behavior, this is a list of possible socket responses, their causes, and resulting Vault behavior:

- log server accepts the connection and acknowledges the writes
  - yay!
  - Everything is working as it should.
  - Vault responds to the client quickly.
- TCP RST
  - The remote server is up but there is no process listening on that port, so the TCP/IP stack sends an immediate RST, letting Vault know there's no service there.
  - Can also happen if a firewall blocks the connection with a reject/RST policy
  - Vault will immediately understand this audit device won't work and moves to the next one.
  - Vault responds to the client quickly.
- No response from log server
  - Either no response to TCP SYN, or no ACK on established connection
  - Can happen if the remote server falls off the network completely and nothing responds on its IP/MAC.
-   Also happens if a firewall (on the network or kernel/iptables) drops the connection with no packets going back to Vault (DROP target).
-   Also happens if the listening log process is to busy to respond or if the machine is swapping.
-   Vault will hang for 8 seconds on each non-responsive socket device.




# How to Reproduce Vault

You don't need a socket log server for this demo. 

1. ./audit-setup.sh # configures a file and a socket audit device (localhost:1515, you don't actually need anything listening there)
1. time vault secrets list # should be fast.
1. ./iptables-drop.sh # drop connections on tcp/1515
1. ./big-kv.sh - fill the audit log buffer? Not sure why this is needed to repro next step.
1. time vault secrets list # should be slow. Vault waits 8s for a server response that never arrives.
1. ./iptables-flush.sh # remove drop rule. 
1. time vault secrets list # should be fast.

