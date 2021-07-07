#!/bin/bash

if [[ $# -eq 0 ]] ; then 
	# No argument
	echo "Usage: Command [plain-text]"
else
	# Encrypt some data
	vault write transit/encrypt/my-key plaintext=$(base64 <<< $*) | grep cipher | awk '{printf $2;}'
    echo
fi