#!/bin/bash

echo "Creating Zowe profile..."

zowe config init --global-config

zowe config set profiles.learn.properties.host 204.90.115.200
zowe config set profiles.learn.properties.port 10443
zowe config set profiles.learn.properties.user $ZOWE_USERNAME
zowe config set profiles.learn.properties.password $ZOWE_PASSWORD
zowe config set profiles.learn.type zosmf
zowe config set profiles.learn.properties.rejectUnauthorized false

echo "Profile created"
# zowe_operations.sh

LOWERCASE_USERNAME=$(echo "$ZOWE_USERNAME" | tr '[:upper:]' '[:lower:]')

# Check if directory exists, create if it doesn't
if ! zowe zos-files list uss-files "/z/$LOWERCASE_USERNAME/cobolcheck" &>/dev/null; then
  echo "Directory does not exist. Creating it..."
  zowe zos-files create uss-directory /z/$LOWERCASE_USERNAME/cobolcheck
else
  echo "Directory already exists."
fi

# Upload files
zowe zos-files upload dir-to-uss "./cobol-check-0.2.19" "/z/$LOWERCASE_USERNAME/cobolcheck" \
  --recursive \
  --binary-files "cobol-check-0.2.19.jar"

# Verify upload
echo "Verifying upload:"
zowe zos-files list uss-files "/z/$LOWERCASE_USERNAME/cobolcheck"
