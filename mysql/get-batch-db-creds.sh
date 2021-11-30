for x in `seq 1 16`; do
  vault read database/creds/db1-5s  | egrep 'username|passw'
  sleep 0.2
done
