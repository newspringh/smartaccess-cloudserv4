# SmartAccess Cinder CSI

## Pinned versions

- Kubernetes: v1.36.6+rke2r1
- Helm chart: cpo/openstack-cinder-csi
- Chart version: 2.36.5
- CSI driver version: v1.36.0

## Persistent storage

Use `csi-cinder-sc-retain` for PostgreSQL and other
stateful SmartAccess services.

- Provisioner: cinder.csi.openstack.org
- Reclaim policy: Retain
- Cinder volume type: __DEFAULT__
- Kubelet directory: /var/lib/kubelet

## Deployment prerequisites

1. Configure OpenStack CCM and Nova provider IDs.
2. Create the Kubernetes cloud-config Secret securely.
3. Configure trusted CA certificates.
4. Install the pinned Cinder CSI Helm chart.
5. Verify PVC provisioning, attachment, and data persistence.

Do not commit OpenStack credentials, cloud.conf, or
unencrypted Kubernetes Secrets.
