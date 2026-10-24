#!/usr/bin/env bash
# ==============================================================================
# ChronoCraft: Google Play Upload Keystore Generator
# ==============================================================================

set -euo pipefail

KEYSTORE_FILE="upload-keystore.jks"
KEY_ALIAS="chronocraft-key"

echo "🔐 Generating Android Release Keystore for Google Play..."

if [ -f "$KEYSTORE_FILE" ]; then
    echo "⚠️ Keystore $KEYSTORE_FILE already exists! Not overwriting."
    exit 0
fi

if ! command -v keytool >/dev/null 2>&1; then
    echo "❌ Error: 'keytool' not found. Please install OpenJDK (e.g., sudo apt install default-jdk)."
    exit 1
fi

keytool -genkeypair -v \
  -keystore "$KEYSTORE_FILE" \
  -alias "$KEY_ALIAS" \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -storetype JKS

echo ""
echo "✅ Keystore generated successfully: $KEYSTORE_FILE"
echo ""
echo "To configure GitHub Actions automated signing:"
echo "1. Run: base64 -w 0 $KEYSTORE_FILE"
echo "2. Add to GitHub Repo Secrets:"
echo "   - KEYSTORE_BASE64: <output from base64>"
echo "   - KEYSTORE_PASSWORD: <your keystore password>"
echo "   - KEY_ALIAS: $KEY_ALIAS"
echo "   - KEY_PASSWORD: <your key password>"
