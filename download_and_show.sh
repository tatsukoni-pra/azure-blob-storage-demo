#!/bin/bash

# Azure Blob Storage Download and Show Script
# Storage Account: sttatsukonidemo
# Container: files

set -e

# 設定
STORAGE_ACCOUNT="sttatsukonidemo"
CONTAINER_NAME="files"
RESOURCE_GROUP="tatsukoni-test-v2"

# 使い方
usage() {
    echo "使い方: $0 <blob名>"
    echo ""
    echo "引数:"
    echo "  blob名    取得するBlobの名前（必須）"
    echo ""
    echo "例:"
    echo "  $0 target_file.txt"
    echo "  $0 renamed-file.txt"
    exit 1
}

# 引数チェック
if [ $# -lt 1 ]; then
    usage
fi

BLOB_NAME="$1"

# Azure CLIインストールチェック
if ! command -v az &> /dev/null; then
    echo "エラー: Azure CLIがインストールされていません"
    echo "インストール方法: https://docs.microsoft.com/cli/azure/install-azure-cli"
    exit 1
fi

# Azureログインチェック
if ! az account show &> /dev/null; then
    echo "Azureにログインしていません。ログインを開始します..."
    az login
fi

# 一時ファイル作成
TEMP_FILE=$(mktemp)
trap "rm -f $TEMP_FILE" EXIT

# ファイルダウンロード
echo "ダウンロード中: $CONTAINER_NAME/$BLOB_NAME"

az storage blob download \
    --account-name "$STORAGE_ACCOUNT" \
    --container-name "$CONTAINER_NAME" \
    --name "$BLOB_NAME" \
    --file "$TEMP_FILE" \
    --auth-mode key

if [ $? -eq 0 ]; then
    echo "✓ ダウンロード成功"
    echo ""
    echo "==================== ファイル内容 ===================="
    cat "$TEMP_FILE"
    echo ""
    echo "======================================================"
else
    echo "✗ ダウンロード失敗"
    exit 1
fi
