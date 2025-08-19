#!/usr/bin/env bash
set -euo pipefail

KEY_EMAIL="test-pass@example.com"
KEY_FPR=$(gpg --list-secret-keys --with-colons "$KEY_EMAIL" | awk -F: '/^fpr:/ {print $10; exit}')

echo "[+] Removing pass store..."
rm -rf "$PASSWORD_STORE_DIR"

echo "[+] Deleting GPG key: $KEY_FPR"
gpg --batch --yes --delete-secret-keys "$KEY_FPR" || true
gpg --batch --yes --delete-keys "$KEY_FPR" || true

echo "[+] Cleanup complete."
