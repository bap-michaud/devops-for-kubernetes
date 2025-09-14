# DevOps for Kubernetes

Battle-tested DevOps pipelines to help you ship code faster and safer on Kubernetes. Learn to build, test, and deploy applications with confidence using these production-ready workflows.

## 🚀 Features

- **Monorepo Architecture**: Unified codebase with selective builds and shared libraries
- **Multi-Platform CI/CD**: GitHub Actions workflows with multi-architecture support
- **Production-Ready**: Battle-tested configurations with security scanning and monitoring
- **Kubernetes Native**: Comprehensive manifests with resilience and high availability features
- **Security First**: Container scanning, SAST, secret detection, and policy enforcement

## 📁 Repository Structure

```
├── applications/           # Application services
│   ├── web-app/           # Sample web application
│   └── api-service/       # Sample API service
├── shared/                # Shared libraries and configurations
│   ├── libraries/         # Common utilities (logger, etc.)
│   └── configs/           # Shared configurations
├── manifests/             # Kubernetes manifests
│   ├── deployments/       # Application deployments
│   ├── services/          # Service definitions
│   ├── ingress/           # Ingress configurations
│   └── ...               # Additional K8s resources
├── .github/workflows/     # GitHub Actions CI/CD pipelines
├── scripts/               # Automation and utility scripts
└── security/              # Security configurations and policies
```

## 🛠️ Quick Start

### Prerequisites

- Node.js 18+
- Docker
- kubectl
- Access to a Kubernetes cluster

### Running Applications Locally

```bash
# Web Application
cd applications/web-app
npm install
npm start
# Access at http://localhost:3000

# API Service
cd applications/api-service
npm install
npm start
# Access at http://localhost:8080
```

### Building Docker Images

```bash
# Build web application
docker build -t web-app applications/web-app

# Build API service
docker build -t api-service applications/api-service
```

### Deploying to Kubernetes

```bash
# Apply all manifests
kubectl apply -f manifests/

# Check deployment status
kubectl get pods
kubectl get services
```

## 🔄 CI/CD Pipeline

The repository includes comprehensive GitHub Actions workflows:

- **Build & Test**: Automated testing with coverage reporting
- **Security Scanning**: Container vulnerability scanning and SAST
- **Container Build**: Multi-architecture Docker builds with signing
- **Deployment**: Environment-specific deployments with approval gates

### Pipeline Features

- ✅ Self-hosted runner with direct cluster access
- ✅ Selective builds (only changed services)
- ✅ Multi-architecture support (AMD64/ARM64)
- ✅ Dependency and Docker layer caching
- ✅ Security scanning with Trivy and CodeQL
- ✅ Container signing with Cosign
- ✅ Direct deployment to dev cluster

## 🔒 Security

- **Container Security**: Base image scanning and runtime security
- **Code Security**: SAST scanning and secret detection
- **Supply Chain**: Image signing and SBOM generation
- **Policy Enforcement**: OPA Gatekeeper policies for Kubernetes

## 📚 Documentation

- [Pipeline Configuration](pipelines/github-actions/README.md)
- [Kubernetes Manifests](manifests/README.md)
- [Application Examples](examples/README.md)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
