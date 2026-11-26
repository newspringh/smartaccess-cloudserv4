#!/usr/bin/env bash
set -euo pipefail

# Join a SmartAccess worker to the existing RKE2 cluster.
# Run on a worker node as root.

if [[ "$EUID" -ne 0 ]]; then
  echo "Run this script as root."
  exit 1
fi

for variable in RKE2_VERSION RKE2_SERVER RKE2_TOKEN_FILE; do
  if [[ -z "${!variable:-}" ]]; then
    echo "Missing required variable: $variable"
    exit 1
  fi
done

if [[ ! -r "$RKE2_TOKEN_FILE" ]]; then
  echo "RKE2 token file is not readable."
  exit 1
fi

if [[ -f /etc/rancher/rke2/config.yaml ]]; then
  echo "RKE2 configuration already exists. No changes made."
  exit 1
fi

install -d -m 0700 /etc/rancher/rke2

install -m 0600 "$RKE2_TOKEN_FILE" \
  /etc/rancher/rke2/agent-token

cat > /etc/rancher/rke2/config.yaml <<CONFIG
server: "${RKE2_SERVER}"
token-file: /etc/rancher/rke2/agent-token
CONFIG

chmod 0600 /etc/rancher/rke2/config.yaml

curl -fsSL https://get.rke2.io -o /tmp/smartaccess-install-rke2.sh

INSTALL_RKE2_TYPE=agent \
INSTALL_RKE2_VERSION="$RKE2_VERSION" \
sh /tmp/smartaccess-install-rke2.sh

systemctl enable --now rke2-agent

echo "RKE2 worker installation initiated."
