# Azure Dynamic Service Principal demo

The scripts in this directory can be used to demonstrate dynamic service principals (SPN) using Vault's Azure secrets engine.

https://www.vaultproject.io/docs/secrets/azure/index.html

initial-azure-sp-setup.sh - Create an initial SPN  that will authenticate Vault to Azure and allow dynamic SPN creation.
01-setup.sh - Enable and configure the Azure secrets engine. 
02-read.sh - Read an SPN from Vault (usually  takes 7-10 seconds for the Azure  API  to complete this task).
watch-sp.sh - Run with "watch -n1" to see the SPN disappear from Azure when the secret expires.
