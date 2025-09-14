# GitHub Actions Pipeline Implementation

This directory contains comprehensive GitHub Actions workflows for building, testing, and deploying Kubernetes applications. The implementation supports both monorepo and multi-repo strategies with production-ready features.

## Features

### Build and Test Capabilities
- **Multi-architecture support**: Builds for both AMD64 and ARM64 architectures
- **Dependency caching**: Intelligent caching for npm dependencies and Docker layers
- **Test execution**: Comprehensive test suites with coverage reporting
- **Code quality**: Linting and static analysis integration
- **Performance testing**: Load testing for API services

### Security Features
- **Container scanning**: Trivy vulnerability scanning for Docker images
- **SAST integration**: Static Application Security Testing
- **Secret detection**: Automated secret scanning and prevention
- **OIDC authentication**: Secure registry access without long-lived tokens

### Repository Strategy Support
- **Monorepo workflows**: Optimized for monolithic repositories with change detection
- **Multi-repo workflows**: Individual service pipelines with cross-service coordination
- **Reusable workflows**: Shared workflow components to reduce duplication

## Workflow Structure

### Monorepo Implementation

```
examples/monorepo/.github/workflows/
├── build-and-test.yml          # Main build and test workflow
├── reusable-build-test.yml     # Reusable workflow for individual services
├── security-scan.yml           # Security scanning workflow
├── container-build.yml         # Container build and push workflow
└── deploy.yml                  # Environment-specific deployment workflow
```

#### Key Features:
- **Change Detection**: Only builds services that have changed
- **Parallel Execution**: Builds multiple services simultaneously
- **Shared Dependencies**: Optimized caching for shared libraries
- **Integration Testing**: Cross-service integration tests

### Multi-repo Implementation

```
examples/multi-repo/{service}/.github/workflows/
├── build-and-test.yml          # Service-specific build and test
├── security-scan.yml           # Security scanning
├── container-build.yml         # Container build and push
└── deploy.yml                  # Deployment workflow
```

#### Key Features:
- **Service Autonomy**: Independent build and deployment cycles
- **Focused Testing**: Service-specific test suites
- **Performance Testing**: Service-level performance validation
- **Isolated Security**: Per-service security scanning

## Workflow Configuration

### Environment Variables

```yaml
env:
  NODE_VERSION: '18'              # Node.js version
  REGISTRY: ghcr.io              # Container registry
  IMAGE_NAME: ${{ github.repository }}
```

### Build Matrix

```yaml
strategy:
  matrix:
    architecture: [amd64, arm64]   # Multi-architecture builds
    service: [web-app, api-service] # Services to build (monorepo)
```

### Caching Strategy

#### Dependency Caching
```yaml
- name: Cache dependencies
  uses: actions/cache@v3
  with:
    path: |
      ~/.npm
      node_modules
    key: ${{ runner.os }}-node-${{ env.NODE_VERSION }}-${{ hashFiles('package-lock.json') }}
```

#### Docker Layer Caching
```yaml
- name: Cache Docker layers
  uses: actions/cache@v3
  with:
    path: /tmp/.buildx-cache
    key: ${{ runner.os }}-buildx-${{ github.sha }}
    restore-keys: |
      ${{ runner.os }}-buildx-
```

## Security Implementation

### Container Scanning with Trivy

```yaml
- name: Run Trivy vulnerability scanner
  uses: aquasecurity/trivy-action@master
  with:
    image-ref: 'app:latest'
    format: 'sarif'
    output: 'trivy-results.sarif'

- name: Upload Trivy scan results
  uses: github/codeql-action/upload-sarif@v2
  with:
    sarif_file: 'trivy-results.sarif'
```

### OIDC Authentication

```yaml
- name: Configure AWS credentials
  uses: aws-actions/configure-aws-credentials@v4
  with:
    role-to-assume: arn:aws:iam::ACCOUNT:role/GitHubActions
    aws-region: us-east-1
```

### Secret Management

```yaml
- name: Login to Container Registry
  uses: docker/login-action@v3
  with:
    registry: ${{ env.REGISTRY }}
    username: ${{ github.actor }}
    password: ${{ secrets.GITHUB_TOKEN }}
```

## Testing Strategy

### Unit Tests
- Jest test framework with coverage reporting
- Parallel test execution across services
- Coverage thresholds enforcement

### Integration Tests
- Cross-service API testing
- Database integration testing
- Service mesh communication validation

### Container Tests
- Multi-stage Docker builds with test stages
- Container startup and health check validation
- Security scanning of built images

### Performance Tests
- Artillery-based load testing
- Response time and throughput validation
- Resource usage monitoring

## Deployment Integration

### Environment Strategy
- **Development**: Automatic deployment on main branch
- **Staging**: Deployment with approval gates
- **Production**: Manual approval with rollback capabilities

### GitOps Integration
- ArgoCD application updates
- Flux synchronization triggers
- Kubernetes manifest validation

## Usage Examples

### Monorepo Workflow Trigger

```yaml
on:
  push:
    branches: [ main, develop ]
    paths:
      - 'applications/**'
      - 'shared/**'
  pull_request:
    branches: [ main, develop ]
```

### Multi-repo Workflow Trigger

```yaml
on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]
  workflow_dispatch:
```

### Reusable Workflow Call

```yaml
jobs:
  build-web-app:
    uses: ./.github/workflows/reusable-build-test.yml
    with:
      service-name: web-app
      working-directory: applications/web-app
      run-integration-tests: true
```

## Best Practices

### Performance Optimization
1. **Parallel Execution**: Run independent jobs in parallel
2. **Selective Building**: Only build changed services
3. **Efficient Caching**: Cache dependencies and Docker layers
4. **Resource Management**: Optimize runner resource usage

### Security Best Practices
1. **Least Privilege**: Minimal required permissions
2. **Secret Management**: Use GitHub secrets and OIDC
3. **Vulnerability Scanning**: Scan all container images
4. **Supply Chain Security**: Verify dependencies and signatures

### Reliability Features
1. **Retry Logic**: Automatic retry for transient failures
2. **Timeout Management**: Prevent hanging builds
3. **Error Handling**: Comprehensive error reporting
4. **Rollback Capabilities**: Quick rollback mechanisms

## Monitoring and Observability

### Build Metrics
- Build duration and success rates
- Test coverage trends
- Security scan results
- Performance test results

### Notifications
- Slack/Teams integration for build status
- Email notifications for failures
- GitHub status checks for PR validation

## Troubleshooting

### Common Issues

#### Cache Misses
```bash
# Clear cache manually
gh api -X DELETE /repos/OWNER/REPO/actions/caches
```

#### Build Failures
```bash
# Debug with tmate
- name: Setup tmate session
  uses: mxschmitt/action-tmate@v3
  if: failure()
```

#### Permission Issues
```yaml
permissions:
  contents: read
  packages: write
  security-events: write
```

## Migration Guide

### From Jenkins
1. Convert Jenkinsfile stages to GitHub Actions jobs
2. Migrate build scripts to workflow steps
3. Update secret management approach
4. Configure new webhook triggers

### From GitLab CI
1. Convert .gitlab-ci.yml to workflow files
2. Migrate CI/CD variables to GitHub secrets
3. Update registry authentication
4. Configure GitHub Pages for artifacts

## Contributing

When adding new workflows:
1. Follow the established naming conventions
2. Include comprehensive error handling
3. Add appropriate caching strategies
4. Document any new environment variables
5. Test with both monorepo and multi-repo structures