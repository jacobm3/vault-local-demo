#!/bin/bash

if [[ $# -eq 0 ]] ; then 
	# No argument
	echo "Usage: Command [plain-text]"
else
	# Hash base64 input
	vault write transit/hash input=$(base64 <<< $*) | grep sum | awk '{printf $2;}'
	echo
fi
