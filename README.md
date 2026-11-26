# SmartAccess

Cloud-native Identity and Access Management platform deployed on
Hochschule Fulda OpenStack CloudServ4.

## Architecture

- Cloud: OpenStack
- Infrastructure as Code: Terraform
- Kubernetes: RKE2
- Initial cluster: 1 Control Plane + 3 Workers
- HA target: 3 Control Planes + 3 Workers
- Resource quota: 20 vCPU / 32 GiB RAM
- Environments: Development and Staging

## Applications

- Keycloak
- midPoint
- PostgreSQL

## Platform

- Helm
- GitHub Actions
- GHCR
- Argo CD
- SOPS + age
- Traefik
- Cinder CSI
- Prometheus
- Grafana
- Alertmanager
- Loki
- Grafana Alloy
- Velero

## Project Objectives

Complete all six core labs:

1. Docker
2. OpenStack
3. Terraform
4. Kubernetes and Helm
5. CI/CD and GitOps
6. Monitoring and Observability

Bonus objectives:

- Backup and Disaster Recovery
- High Availability
- Self-Healing
- Auto-Scaling

## Repository Structure

- `infra/` — OpenStack infrastructure and Terraform
- `kubernetes/` — RKE2 and cluster configuration
- `helm/` — Application Helm charts
- `gitops/` — Argo CD application definitions
- `app/` — Custom SmartAccess demo service
- `.github/workflows/` — CI pipelines
- `scripts/` — Operational scripts
- `tests/` — Automated and integration tests
- `docs/` — Architecture and operational documentation

## Status

Phase 1: Repository and CI foundation.

## Security

Credentials, private keys, Terraform state, and decrypted
secrets must remain outside version control.
