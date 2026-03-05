#!/bin/bash
# zowe_operations.sh

LOWERCASE_USERNAME=$(echo "$ZOWE_USERNAME" | tr '[:upper:]' '[:lower:]')
COBOL_CHECK_FOLDER="cobol-check-0.2.19"

# Check directory
if ! zowe zos-files list uss-files "/z/$LOWERCASE_USERNAME/cobolcheck" &>/dev/null; then
  echo "Creating directory..."
  zowe zos-files create uss-directory "/z/$LOWERCASE_USERNAME/cobolcheck"
else
  echo "Directory exists."
fi

# Upload files
zowe zos-files upload dir-to-uss "./$COBOL_CHECK_FOLDER" "/z/$LOWERCASE_USERNAME/cobolcheck" --recursive --binary-files "*.jar"

# Verify upload
zowe zos-files list uss-files "/z/$LOWERCASE_USERNAME/cobolcheck"
