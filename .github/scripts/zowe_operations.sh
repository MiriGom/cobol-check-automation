#!/bin/bash
# .github/scripts/zowe_operations.sh

LOWERCASE_USERNAME=$(echo "$ZOWE_USERNAME" | tr '[:upper:]' '[:lower:]')
COBOL_CHECK_FOLDER="cobol-check-0.2.19"

# Check if directory exists; create if it doesn't
if ! zowe zos-files list uss-files "/z/$LOWERCASE_USERNAME/cobolcheck" &>/dev/null; then
  echo "Directory does not exist. Creating it..."
  zowe zos-files create uss-directory "/z/$LOWERCASE_USERNAME/cobolcheck"
else
  echo "Directory already exists."
fi

# Upload files recursively
echo "Uploading COBOL Check files..."
zowe zos-files upload dir-to-uss "./$COBOL_CHECK_FOLDER" "/z/$LOWERCASE_USERNAME/cobolcheck" --recursive --binary-files "*.jar"

# Verify upload
echo "Verifying upload:"
zowe zos-files list uss-files "/z/$LOWERCASE_USERNAME/cobolcheck"
