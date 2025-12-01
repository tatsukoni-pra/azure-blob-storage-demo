#!/bin/bash

# バックアップ有効化後の設定確認スクリプト

STORAGE_ACCOUNT="sttatsukonidemo"
RESOURCE_GROUP="tatsukoni-test-v2"
VAULT_NAME="backupcontainerdemo"

echo "=== ストレージアカウントのデータ保護設定 ==="
az storage account blob-service-properties show \
  --account-name $STORAGE_ACCOUNT \
  --resource-group $RESOURCE_GROUP \
  --query "{ポイントインタイムリストア: restorePolicy.days, 論理的な削除: deleteRetentionPolicy.days, バージョン管理: isVersioningEnabled, 変更フィード: changeFeed.enabled}" \
  --output table

echo ""
echo "=== バックアップインスタンスの状態 ==="
az dataprotection backup-instance list \
  --resource-group $RESOURCE_GROUP \
  --vault-name $VAULT_NAME \
  --query "[].{Name:name, 保護状態:properties.currentProtectionState, ポリシー:properties.policyInfo.name}" \
  --output table

echo ""
echo "=== バックアップポリシーの保持期間 ==="
az dataprotection backup-policy show \
  --resource-group $RESOURCE_GROUP \
  --vault-name $VAULT_NAME \
  --name BlobOperationalBackupPolicy \
  --query "properties.policyRules[0].lifecycles[0].deleteAfter.duration" \
  --output tsv
