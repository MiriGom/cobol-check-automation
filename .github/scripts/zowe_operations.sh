#!/bin/bash
set -e  # Stop on any error

# Convert username to lowercase
LOWERCASE_USERNAME=$(echo "$ZOWE_USERNAME" | tr '[:upper:]' '[:lower:]')

# Ensure Zowe CLI is installed
if ! command -v zowe &>/dev/null; then
  echo "Zowe CLI not found. Installing..."
  npm install -g @zowe/cli
fi

# Verify profile exists
PROFILE="LearnCOBOL"
echo "Using Zowe profile: $PROFILE"

# Check if COBOL Check directory exists
echo "Checking if USS directory exists..."
if ! zowe files list uss-files "/z/$LOWERCASE_USERNAME/cobolcheck" --zosmf-profile $PROFILE &>/dev/null; then
  echo "Directory does not exist. Creating..."
  zowe files create uss-directory "/z/$LOWERCASE_USERNAME/cobolcheck" --zosmf-profile $PROFILE
else
  echo "Directory already exists."
fi

# Upload COBOL Check files (adjust folder version as needed)
COBOL_CHECK_DIR="cobol-check-0.2.19"
echo "Uploading $COBOL_CHECK_DIR..."
zowe files upload dir-to-uss "./$COBOL_CHECK_DIR" "/z/$LOWERCASE_USERNAME/cobolcheck" --recursive --zosmf-profile $PROFILE

# Verify upload
echo "Verifying upload..."
zowe files list uss-files "/z/$LOWERCASE_USERNAME/cobolcheck" --zosmf-profile $PROFILE
echo "Zowe operations completed successfully!"
