#!/bin/bash

# Enable transit engine
vault secrets enable transit

# Generate encryption / decryption keys
vault write -f transit/keys/my-key
