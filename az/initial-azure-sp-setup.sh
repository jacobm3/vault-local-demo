#!/bin/bash

unset AZURE_SUBSCRIPTION_ID AZURE_TENANT_ID AZURE_CLIENT_ID AZURE_CLIENT_SECRET
unset ARM_SUBSCRIPTION_ID ARM_TENANT_ID ARM_CLIENT_ID ARM_CLIENT_SECRET

SPNAME=asdf

ARM_TENANT_ID=asdf
ARM_SUBSCRIPTION_ID=asdf

az account set --subscription $ARM_SUBSCRIPTION_ID
spjson=$(az ad sp create-for-rbac --role="Owner" --name="http://local/${SPNAME}" --scopes="/subscriptions/${ARM_SUBSCRIPTION_ID}" 2>err )
echo "Service Principal:"
echo $spjson

ARM_CLIENT_ID=$(echo $spjson  | jq -r .appId)
ARM_CLIENT_SECRET=$(echo $spjson  | jq -r .password)

# Azure AD, "Read and write all apps", "Read and  write directory data"
# for more info:
# https://blogs.msdn.microsoft.com/aaddevsup/2018/06/06/guid-table-for-windows-azure-active-directory-permissions/
az ad app permission add \
    --id $ARM_CLIENT_ID \
    --api 00000002-0000-0000-c000-000000000000 \
    --api-permissions 1cda74f2-2616-4834-b122-5cb1b07f8a59=Role 78c8a3c8-a07e-4b9e-af1b-b5ccab50a175=Role \

az ad app permission grant --id $ARM_CLIENT_ID --api 00000002-0000-0000-c000-000000000000 --expires never

az ad app permission admin-consent --id $ARM_CLIENT_ID

echo "Azure env vars:"
echo "export ARM_TENANT_ID=$ARM_TENANT_ID"
echo "export ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID"
echo "export ARM_CLIENT_ID=$ARM_CLIENT_ID"
echo "export ARM_CLIENT_SECRET=$ARM_CLIENT_SECRET"

echo
echo "You can delete this SP with the following command: az ad sp delete --id $ARM_CLIENT_ID"
