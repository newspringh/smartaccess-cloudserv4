#!/usr/bin/env bash
set -euo pipefail

# Install the first RKE2 control-plane server.
# Run on smartaccess-cp01 as root.

if [[ "$EUID" -ne 0 ]]; then
  echo "Run this script as root."
  exit 1
fi

if [[ -z "${RKE2_VERSION:-}" ]]; then
  echo "RKE2_VERSION must be set to an approved release."
  exit 1
fi

if [[ -z "${RKE2_TLS_SAN:-}" ]]; then
  echo "RKE2_TLS_SAN must contain the management API address."
  exit 1
fi

if [[ -f /etc/rancher/rke2/config.yaml ]]; then
  echo "RKE2 configuration already exists. No changes made."
  exit 1
fi

install -d -m 0700 /etc/rancher/rke2

cat > /etc/rancher/rke2/config.yaml <<CONFIG
write-kubeconfig-mode: "0600"
tls-san:
  - "${RKE2_TLS_SAN}"
etcd-snapshot-schedule-cron: "0 */6 * * *"
etcd-snapshot-retention: 5
CONFIG

curl -fsSL https://get.rke2.io -o /tmp/smartaccess-install-rke2.sh

INSTALL_RKE2_TYPE=server \
INSTALL_RKE2_VERSION="$RKE2_VERSION" \
sh /tmp/smartaccess-install-rke2.sh

systemctl enable --now rke2-server

echo "RKE2 control-plane installation initiated."
