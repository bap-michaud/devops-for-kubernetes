# Multi-Repo Examples

This directory demonstrates a multi-repository approach for Kubernetes DevOps pipelines.

## Structure

Each service lives in its own repository with independent:
- Source code and dependencies
- CI/CD pipelines  
- Release cycles
- Team ownership

```
multi-repo/
├── web-app/              # Standalone web application repository
│   ├── src/              # Application source code
│   ├── Dockerfile        # Container build configuration
│   ├── package.json      # Dependencies and scripts
│   └── .github/          # GitHub Actions workflows (future)
├── api-service/          # Standalone API service repository  
│   ├── src/              # Application source code
│   ├── Dockerfile        # Container build configuration
│   ├── package.json      # Dependencies and scripts
│   └── .github/          # GitHub Actions workflows (future)
└── shared-lib/           # Shared library repository (future)
    ├── lib/              # Reusable library code
    ├── package.json      # Library dependencies
    └── .github/          # Library-specific CI/CD
```

## Applications

### Web App Repository
- **Technology**: Node.js + Express
- **Port**: 3000
- **Repository**: `org/web-app`
- **Purpose**: Frontend web application

### API Service Repository
- **Technology**: Node.js + Express  
- **Port**: 8080
- **Repository**: `org/api-service`
- **Purpose**: Backend API service

## Advantages of This Structure

1. **Team Autonomy**: Independent development and deployment
2. **Technology Flexibility**: Different tech stacks per service
3. **Fault Isolation**: Issues in one repo don't affect others
4. **Granular Access**: Repository-level permissions
5. **Parallel Development**: Teams work independently

## Development Workflow

```bash
# Each repository is developed independently
git clone https://github.com/org/web-app.git
cd web-app
npm install
npm start

# Separate repository for API service
git clone https://github.com/org/api-service.git  
cd api-service
npm install
npm start
```

## Dependency Management

### Internal Dependencies
- Published as npm packages
- Versioned releases with semantic versioning
- Dependency updates via package.json

### Cross-Service Communication
- API contracts and OpenAPI specs
- Service discovery via Kubernetes DNS
- Environment-specific service endpoints

## CI/CD Considerations

- Independent pipelines per repository
- Service-specific build and test processes
- Coordinated deployments via GitOps
- Cross-service integration testing

## When to Use Multi-Repo

✅ **Good fit when:**
- Team size > 50 developers
- Loosely coupled services
- Independent release cycles
- Diverse technology stacks
- Strong team ownership model

❌ **Consider alternatives when:**
- Small, tightly coupled services
- Frequent cross-service changes
- Homogeneous technology stack
- Centralized DevOps team

## Migration Strategy

### From Monorepo to Multi-Repo
1. Identify service boundaries
2. Extract shared libraries first
3. Split services incrementally
4. Update CI/CD pipelines
5. Migrate team ownership

### From Multi-Repo to Monorepo
1. Consolidate shared dependencies
2. Merge repositories gradually
3. Unify build processes
4. Coordinate team workflows