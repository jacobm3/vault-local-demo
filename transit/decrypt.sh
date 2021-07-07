#!/bin/bash

if [[ $# -eq 0 ]]; then 
	# No argument
	echo "Usage: Command [cipher text]"
else
	# Decrypt some data
	vault write transit/decrypt/my-key ciphertext="$1" | grep plaintext | awk '{printf $2;}' | base64 -d
fi

