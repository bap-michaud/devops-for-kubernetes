# Monorepo Example

This directory demonstrates a monorepo approach for Kubernetes DevOps pipelines.

## Structure

```
monorepo/
├── applications/           # All application services
│   ├── web-app/           # Frontend web application
│   │   ├── src/           # Application source code
│   │   ├── Dockerfile     # Multi-stage container build
│   │   └── package.json   # Dependencies and scripts
│   └── api-service/       # Backend API service
│       ├── src/           # Application source code
│       ├── Dockerfile     # Multi-stage container build
│       └── package.json   # Dependencies and scripts
├── shared/                # Shared code and configurations
│   ├── libraries/         # Common utilities and libraries
│   └── configs/           # Shared configuration files
└── infrastructure/        # Infrastructure as code (future)
    ├── terraform/         # Terraform configurations
    └── helm-charts/       # Helm chart templates
```

## Applications

### Web App
- **Technology**: Node.js + Express
- **Port**: 3000
- **Purpose**: Frontend web application with health endpoints

### API Service  
- **Technology**: Node.js + Express
- **Port**: 8080
- **Purpose**: Backend API with RESTful endpoints

## Shared Components

### Libraries
- **Logger**: Structured JSON logging utility
- **Config**: Common configuration management

### Configurations
- Environment-specific settings
- Security configurations
- Database connection settings

## Advantages of This Structure

1. **Unified Versioning**: All services versioned together
2. **Atomic Changes**: Cross-service changes in single commits
3. **Shared Code**: Easy reuse of common libraries
4. **Consistent Tooling**: Same build and deployment processes
5. **Simplified Dependencies**: Internal dependencies managed easily

## Development Workflow

```bash
# Install all dependencies
npm install

# Run specific service
cd applications/web-app
npm start

# Run tests for all services
npm run test:all

# Build all Docker images
npm run build:all
```

## CI/CD Considerations

- Single pipeline for all services
- Selective building based on changed files
- Shared build cache and artifacts
- Coordinated deployments across services

## When to Use Monorepo

✅ **Good fit when:**
- Team size < 50 developers
- Tightly coupled services
- Frequent cross-service changes
- Homogeneous technology stack
- Strong emphasis on code sharing

❌ **Consider alternatives when:**
- Large, distributed teams
- Independent service lifecycles
- Diverse technology requirements
- Strong team autonomy needs