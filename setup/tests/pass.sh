#!/usr/bin/env bash

set -euo pipefail

# Variables
KEY_NAME="TestPassKey"
KEY_EMAIL="test-pass@example.com"
KEY_COMMENT="Temporary test key"

# Create batch file for RSA key (safe & portable)
cat > gen-key-batch <<EOF
%no-protection
Key-Type: RSA
Key-Length: 2048
Subkey-Type: RSA
Subkey-Length: 2048
Name-Real: $KEY_NAME
Name-Comment: $KEY_COMMENT
Name-Email: $KEY_EMAIL
Expire-Date: 0
%commit
EOF

echo "[+] Generating dummy GPG key..."
gpg --batch --gen-key gen-key-batch
rm -f gen-key-batch

# Extract key fingerprint
KEY_FPR=$(gpg --list-secret-keys --with-colons "$KEY_EMAIL" | awk -F: '/^fpr:/ {print $10; exit}')
echo "[+] Generated key with fingerprint: $KEY_FPR"

# Init pass with this key
echo "[+] Initializing pass..."
pass init "$KEY_FPR"

# Insert dummy secret
echo "[+] Inserting test entry into pass..."
echo "supersecretpassword" | pass insert -f test/example

echo "[+] Retrieving test entry..."
echo "pass show test/example"

# Run cleanup script
# echo "[+] Running cleanup..."
# bash "$CLEANUP_SCRIPT" "$KEY_FPR"
