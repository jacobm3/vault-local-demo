# Vault hangs with non-responsive audit socket

Vault will skip non-functioning audit devices as long as it can successfully log the audit message to one audit device. Vault may hang for 8 seconds per device under some circumstances.

Assuming the customer has a working file audit device configured and a socket device of varying behavior, this is a list of possible socket responses, their causes, and resulting Vault behavior:

- log server accepts the connection and acknowledges the writes
  - yay!
  - Everything is working as it should.
  - Vault responds to the client quickly.
- TCP RST
  - The remote server is up but there is no process listening on that port, so the TCP/IP stack sends an immediate RST, letting Vault know there's no service there.
  - Can also happen if a firewall blocks the connection with a reject/RST policy
  - Vault immediately understands this audit device won't work and moves to the next one.
  - Vault responds to the client quickly.
- No response from log server
  - Either no response to TCP SYN, or no ACK on established connection
  - Can happen if the remote server falls off the network completely and nothing responds on its IP/MAC.
-   Also happens if a firewall (on the network or kernel/iptables) drops the connection with no packets going back to Vault (DROP target).
-   Also happens if the listening log process is too busy to respond or if the machine is swapping.
-   Vault hangs for 8 seconds on each non-responsive socket device.




# How to Reproduce Vault

You don't need a socket log server for this demo. 

- ./audit-setup.sh 
  - Configures a file and a socket audit device (localhost:1515, you don't actually need anything listening there)
- time vault secrets list 
  - Should be fast.
- ./iptables-drop.sh 
  - Drop connections on tcp/1515
- ./big-kv.sh
  - Fill the audit log buffer? Not sure why this is needed to repro next step.
- time vault secrets list
  - Should be slow. Vault waits 8s for a server response that never arrives.
- ./iptables-flush.sh
  - Remove drop rule. 
- time vault secrets list 
  - Should be fast.

