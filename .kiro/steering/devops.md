# DevOps Environment Configuration

## GitHub Actions Infrastructure
- **Runner**: `self-hosted` - Custom GitHub Actions runner for enhanced control and performance
- **Kubernetes Cluster**: `dev` - Development cluster for testing and deployment validation

## Environment Details
The self-hosted GitHub runner provides:
- Direct access to the `dev` Kubernetes cluster
- Faster build times compared to GitHub-hosted runners
- Custom tooling and configurations pre-installed
- Enhanced security for sensitive operations

## Deployment Strategy
- Use the `dev` cluster for:
  - Feature branch testing
  - Integration testing
  - Deployment validation
  - Performance testing in a controlled environment

## Runner Configuration
When creating GitHub Actions workflows, target the self-hosted runner:
```yaml
runs-on: self-hosted
```

## Kubernetes Context
The runner has kubectl configured with access to the `dev` cluster context, enabling direct deployment and testing operations.