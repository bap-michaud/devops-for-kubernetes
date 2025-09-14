# DevOps Pipeline Examples

This directory contains practical examples demonstrating both monorepo and multi-repo strategies for Kubernetes DevOps pipelines.

## Structure

```
examples/
├── monorepo/           # Complete monorepo example
│   ├── applications/   # Application services
│   ├── shared/         # Shared libraries and configs
│   └── infrastructure/ # Infrastructure as code
└── multi-repo/         # Multi-repo examples
    ├── web-app/        # Standalone web application
    ├── api-service/    # Standalone API service
    └── shared-lib/     # Shared library example
```

## Repository Strategies

### Monorepo Approach
- **Location**: `./monorepo/`
- **Best for**: Tightly coupled services, small to medium teams
- **Advantages**: Unified versioning, atomic changes, shared tooling
- **Disadvantages**: Build complexity, scaling challenges

### Multi-repo Approach  
- **Location**: `./multi-repo/`
- **Best for**: Loosely coupled services, large teams, diverse tech stacks
- **Advantages**: Team autonomy, technology flexibility, fault isolation
- **Disadvantages**: Dependency management complexity, tooling overhead

## Sample Applications

Both strategies include:

### Web Application
- **Port**: 3000
- **Endpoints**: `/`, `/health`, `/ready`, `/metrics`
- **Features**: Health checks, Prometheus metrics, graceful shutdown

### API Service
- **Port**: 8080  
- **Endpoints**: `/api/v1/*`, `/health`, `/ready`, `/metrics`
- **Features**: RESTful API, health monitoring, structured logging

## Docker Images

All applications include:
- Multi-stage builds for optimized image size
- Non-root user execution for security
- Health checks for container orchestration
- Graceful shutdown handling
- Security best practices (updated base images, minimal attack surface)

## Getting Started

### Running Locally

```bash
# Monorepo web app
cd examples/monorepo/applications/web-app
npm install
npm start

# Multi-repo API service
cd examples/multi-repo/api-service  
npm install
npm start
```

### Building Docker Images

```bash
# Build monorepo web app
docker build -t monorepo-web-app examples/monorepo/applications/web-app

# Build multi-repo API service
docker build -t multi-repo-api-service examples/multi-repo/api-service
```

### Testing

```bash
# Run tests for any application
cd examples/[monorepo|multi-repo]/[app-name]
npm test
```

## Next Steps

1. Choose your repository strategy based on team size and requirements
2. Implement CI/CD pipelines using the configurations in `pipelines/`
3. Deploy to Kubernetes using the manifests in `k8s/`
4. Set up monitoring and observability with the provided configurations

For detailed implementation guidance, see the main project documentation.