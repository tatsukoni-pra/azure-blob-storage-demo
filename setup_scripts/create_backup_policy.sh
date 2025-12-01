#!/bin/bash

VAULT_NAME="backupcontainerdemo"
RESOURCE_GROUP="tatsukoni-test-v2"
POLICY_NAME="BlobOperationalBackupPolicy"

# ポリシー作成
az dataprotection backup-policy create \
  --resource-group $RESOURCE_GROUP \
  --vault-name $VAULT_NAME \
  --name $POLICY_NAME \
  --policy blob-operational-policy.json