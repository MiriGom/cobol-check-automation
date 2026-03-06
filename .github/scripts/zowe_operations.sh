#!/bin/bash
set -e

LOWERCASE_USERNAME=$(echo "$ZOWE_USERNAME" | tr '[:upper:]' '[:lower:]')

# Install Zowe CLI if missing
if ! command -v zowe &>/dev/null; then
  echo "Zowe CLI not found. Installing..."
  npm install -g @zowe/cli
fi

# Create non-interactive profile on ephemeral runner
zowe profiles create zosmf LearnCOBOL \
  --host 204.90.115.200 \
  --port 10443 \
  --user $ZOWE_USERNAME \
  --password $ZOWE_PASSWORD \
  --reject-unauthorized false \
  --ow true \
  || echo "Profile already exists"

echo "Using Zowe profile: LearnCOBOL"

# Check and create COBOL Check directory
if ! zowe files list uss-files "/z/$LOWERCASE_USERNAME/cobolcheck" --zosmf-profile LearnCOBOL &>/dev/null; then
  echo "Directory does not exist. Creating..."
  zowe files create uss-directory "/z/$LOWERCASE_USERNAME/cobolcheck" --zosmf-profile LearnCOBOL
else
  echo "Directory already exists."
fi

# Upload COBOL Check files
COBOL_CHECK_DIR="cobol-check-0.2.19"
echo "Uploading $COBOL_CHECK_DIR..."
zowe files upload dir-to-uss "./$COBOL_CHECK_DIR" "/z/$LOWERCASE_USERNAME/cobolcheck" --recursive --zosmf-profile LearnCOBOL

# Verify upload
echo "Verifying upload..."
zowe files list uss-files "/z/$LOWERCASE_USERNAME/cobolcheck" --zosmf-profile LearnCOBOL
echo "Zowe operations completed successfully!"
