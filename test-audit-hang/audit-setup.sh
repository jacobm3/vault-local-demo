#!/bin/bash

vault audit enable file file_path=/dev/null 

vault audit enable socket address=127.0.0.1:1515 socket_type=tcp hmac_accessor=false log_raw=true
