#!/bin/bash

# Azure Blob Storage Upload Script
# Storage Account: sttatsukonidemo
# Container: files

set -e

# 設定
STORAGE_ACCOUNT="sttatsukonidemo"
CONTAINER_NAME="files"
RESOURCE_GROUP="tatsukoni-test-v2"

# 使い方
usage() {
    echo "使い方: $0 <ファイルパス> [blob名]"
    echo ""
    echo "引数:"
    echo "  ファイルパス    アップロードするローカルファイルのパス（必須）"
    echo "  blob名          Azure上でのファイル名（省略時はローカルファイル名を使用）"
    echo ""
    echo "例:"
    echo "  $0 ./sample.txt"
    echo "  $0 ./sample.txt renamed-file.txt"
    exit 1
}

# 引数チェック
if [ $# -lt 1 ]; then
    usage
fi

FILE_PATH="$1"
BLOB_NAME="${2:-$(basename "$FILE_PATH")}"

# ファイル存在チェック
if [ ! -f "$FILE_PATH" ]; then
    echo "エラー: ファイルが見つかりません: $FILE_PATH"
    exit 1
fi

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

# ファイルアップロード
echo "アップロード中: $FILE_PATH -> $CONTAINER_NAME/$BLOB_NAME"

az storage blob upload \
    --account-name "$STORAGE_ACCOUNT" \
    --container-name "$CONTAINER_NAME" \
    --name "$BLOB_NAME" \
    --file "$FILE_PATH" \
    --auth-mode key \
    --overwrite

if [ $? -eq 0 ]; then
    echo "✓ アップロード成功"
    echo "Blob URL: https://${STORAGE_ACCOUNT}.blob.core.windows.net/${CONTAINER_NAME}/${BLOB_NAME}"
else
    echo "✗ アップロード失敗"
    exit 1
fi
