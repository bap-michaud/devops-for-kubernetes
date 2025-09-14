# DevOps Pipeline Examples

This directory contains practical examples demonstrating monorepo strategies for Kubernetes DevOps pipelines.

## Structure

The repository is organized as a monorepo with the following structure:

```
├── applications/       # Application services
│   ├── web-app/       # Web application service
│   └── api-service/   # API service
├── shared/            # Shared libraries and configs
│   ├── libraries/     # Common utilities
│   └── configs/       # Shared configurations
├── manifests/         # Kubernetes manifests
├── pipelines/         # CI/CD pipeline configurations
└── scripts/           # Automation scripts
```

## Monorepo Approach

This repository demonstrates a monorepo strategy that provides:
- **Unified versioning**: All services versioned together
- **Atomic changes**: Cross-service changes in single commits
- **Shared tooling**: Consistent build, test, and deployment tools
- **Code reuse**: Centralized shared libraries and utilities
- **Simplified dependencies**: Easier cross-service dependency management

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
# Web application
cd applications/web-app
npm install
npm start

# API service
cd applications/api-service  
npm install
npm start
```

### Building Docker Images

```bash
# Build web app
docker build -t web-app applications/web-app

# Build API service
docker build -t api-service applications/api-service
```

### Testing

```bash
# Run tests for any application
cd applications/[app-name]
npm test
```

## Next Steps

1. Implement CI/CD pipelines using the GitHub Actions workflows in `.github/workflows/`
2. Deploy to Kubernetes using the manifests in `manifests/`
3. Set up monitoring and observability with the provided configurations
4. Customize the shared libraries and configurations for your specific needs

For detailed implementation guidance, see the main project documentation.