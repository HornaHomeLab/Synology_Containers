#!/bin/bash

# Downloads the root CA certificate from Vault PKI mount and saves it locally
# Usage: ./fetch-root-ca.sh

PKI_MOUNT="pki"                # Adjust if your PKI mount path is different
OUTPUT_FILE="root-ca.crt"

# Check Vault auth
if ! vault token lookup >/dev/null 2>&1; then
    echo "❌ You are not logged into Vault. Run: vault login <token>"
    exit 1
fi

echo "📥 Downloading root CA from Vault..."

vault read -field certificate "${PKI_MOUNT}/cert/ca" >"$OUTPUT_FILE"

if [ -s "$OUTPUT_FILE" ]; then
    echo "✅ Root CA saved to $OUTPUT_FILE"
else
    echo "❌ Failed to fetch root CA."
    exit 1
fi
