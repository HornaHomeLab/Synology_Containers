#!/bin/bash

# Usage: ./vault-fetch-cert.sh <common_name>
# Example: ./vault-fetch-cert.sh grafana.horna.local

COMMON_NAME="$1"
VAULT_MOUNT="cert-secrets"

if [ -z "$COMMON_NAME" ]; then
    echo "❌ Usage: $0 <common_name>"
    exit 1
fi

# Ensure Vault CLI is authenticated
if ! vault token lookup >/dev/null 2>&1; then
    echo "❌ You are not logged into Vault. Run: vault login <token>"
    exit 1
fi

# Read the full secret using KV v2 pathing (no /data/!)
SECRET_JSON=$(vault kv get -mount="$VAULT_MOUNT" -format=json "$COMMON_NAME")

if [ -z "$SECRET_JSON" ]; then
    echo "❌ Could not find entry for ${COMMON_NAME}"
    exit 1
fi

# Create output directory
OUTPUT_DIR="${COMMON_NAME}"
mkdir -p "$COMMON_NAME"

# Extract and write fields using jq
echo "$SECRET_JSON" | jq -r '.data.data.certificate'        > "${OUTPUT_DIR}/cert.crt"
echo "$SECRET_JSON" | jq -r '.data.data.private_key'        > "${OUTPUT_DIR}/cert.key"
echo "$SECRET_JSON" | jq -r '.data.data.issuing_ca'         > "${OUTPUT_DIR}/ca.crt"

echo "📅 Issued At: $(echo "$SECRET_JSON" | jq -r '.data.metadata.custom_metadata.issued_at // "Not set"')"
echo "⏳ Expiration: $(echo "$SECRET_JSON" | jq -r '.data.metadata.custom_metadata.expires_at // "Not set"')"
echo ""
echo "✅ Certificate data saved to: $OUTPUT_DIR"