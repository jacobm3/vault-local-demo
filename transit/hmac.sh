#!/bin/bash

if [[ $# -eq 0 ]] ; then 
	# No argument
	echo "Usage: Command [plain-text]"
else
	# Encrypt some data
	vault write transit/hmac/my-key input=$(base64 <<< $*) | grep hmac | awk '{printf $2;}'
    echo
fi
