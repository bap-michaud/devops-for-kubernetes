# DevOps Environment Configuration

## GitHub Actions Infrastructure - Hybrid Approach
- **GitHub-hosted runners** (`ubuntu-latest`): For build, test, security scanning, and container operations
- **Self-hosted runner**: Only for Kubernetes deployment operations requiring direct cluster access
- **Kubernetes Cluster**: `dev` - Development cluster for deployment validation

## Runner Strategy
### GitHub-hosted runners for:
- Code building and testing
- Security scanning (SAST, dependency scanning, container scanning)
- Container building and pushing to registry
- Artifact uploads and general CI operations

### Self-hosted runner for:
- Kubernetes deployments to `dev` cluster
- Direct kubectl operations
- Cluster-specific validations

## Environment Details
The self-hosted GitHub runner provides:
- Direct access to the `dev` Kubernetes cluster
- Pre-configured kubectl with `dev` cluster context
- Enhanced security for deployment operations

## Runner Configuration Examples
```yaml
# For general CI operations
runs-on: ubuntu-latest

# For Kubernetes deployments only
runs-on: self-hosted
```

## Kubernetes Context
The self-hosted runner has kubectl configured with access to the `dev` cluster context for deployment operations.

## GitHub Actions Best Practices

### Artifact Management
- **REQUIRED**: Use `actions/upload-artifact@v4` or newer
- **DEPRECATED**: `actions/upload-artifact@v3` is deprecated and shall not be used
- **REQUIRED**: Use `actions/download-artifact@v4` or newer
- **DEPRECATED**: `actions/download-artifact@v3` is deprecated and shall not be used

### Action Version Guidelines
- Always use the latest stable versions of GitHub Actions
- Pin action versions to specific releases for reproducibility
- Regularly update action versions to benefit from security fixes and improvements