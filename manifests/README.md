# Kubernetes Manifests with Resilience Features

This directory contains production-ready Kubernetes manifests that implement comprehensive resilience, security, and high availability features for containerized applications.

## Directory Structure

```
manifests/
├── deployments/           # Application deployment configurations
├── services/             # Service exposure configurations
├── ingress/              # Ingress and routing configurations
├── network-policies/     # Network security policies
├── disruption/           # Pod disruption budgets
├── autoscaling/          # Horizontal pod autoscalers
├── priority/             # Priority classes for workload scheduling
├── rbac/                 # Service accounts and RBAC configurations
└── README.md            # This documentation
```

## Resilience Features Implemented

### 1. Resource Management
- **Resource Requests and Limits**: Proper CPU, memory, and ephemeral storage limits
- **Quality of Service**: Guaranteed QoS through equal requests and limits
- **Resource Quotas**: Namespace-level resource constraints (to be implemented)

### 2. Health Monitoring
- **Startup Probes**: Allow applications time to start before other probes begin
- **Readiness Probes**: Control traffic routing based on application readiness
- **Liveness Probes**: Restart unhealthy containers automatically
- **Graceful Shutdown**: PreStop hooks for clean application termination

### 3. High Availability
- **Pod Anti-Affinity**: Distribute pods across nodes and availability zones
- **Pod Disruption Budgets**: Maintain minimum availability during voluntary disruptions
- **Rolling Updates**: Zero-downtime deployments with configurable surge and unavailability
- **Multiple Replicas**: Default 3 replicas for redundancy

### 4. Auto-Scaling
- **Horizontal Pod Autoscaler**: Scale based on CPU, memory, and custom metrics
- **Scaling Policies**: Conservative scale-down, aggressive scale-up behaviors
- **Custom Metrics**: Support for application-specific scaling triggers

### 5. Security
- **Network Policies**: Micro-segmentation and traffic isolation
- **Security Contexts**: Non-root containers, read-only filesystems
- **Service Accounts**: Dedicated accounts with minimal permissions
- **Pod Security Standards**: Restricted security contexts

### 6. Workload Prioritization
- **Priority Classes**: Ensure critical workloads are scheduled first
- **Node Affinity**: Prefer specific node types for optimal performance
- **Tolerations**: Handle node taints and maintenance scenarios

## Deployment Order

Deploy the manifests in the following order to avoid dependency issues:

1. **Priority Classes**
   ```bash
   kubectl apply -f manifests/priority/
   ```

2. **RBAC Resources**
   ```bash
   kubectl apply -f manifests/rbac/
   ```

3. **Network Policies** (if using a CNI that supports them)
   ```bash
   kubectl apply -f manifests/network-policies/
   ```

4. **Deployments**
   ```bash
   kubectl apply -f manifests/deployments/
   ```

5. **Services**
   ```bash
   kubectl apply -f manifests/services/
   ```

6. **Ingress** (ensure ingress controller is installed)
   ```bash
   kubectl apply -f manifests/ingress/
   ```

7. **Disruption Budgets**
   ```bash
   kubectl apply -f manifests/disruption/
   ```

8. **Autoscaling** (ensure metrics server is installed)
   ```bash
   kubectl apply -f manifests/autoscaling/
   ```

## Prerequisites

### Required Cluster Components
- **Metrics Server**: For HPA functionality
- **Ingress Controller**: NGINX Ingress Controller recommended
- **CNI with NetworkPolicy Support**: Calico, Cilium, or similar
- **Cert-Manager**: For TLS certificate management (optional)

### Cluster Configuration
- **Node Labels**: Ensure nodes are labeled appropriately for affinity rules
- **Availability Zones**: Multi-zone cluster recommended for anti-affinity
- **Resource Monitoring**: Prometheus and Grafana for metrics collection

## Customization

### Environment-Specific Values
Update the following values for your environment:

1. **Domain Names** in `ingress/app-ingress.yaml`
2. **Resource Limits** in deployment manifests based on your application needs
3. **Replica Counts** based on your traffic patterns
4. **Network CIDR Ranges** in network policies
5. **Node Selectors** and affinity rules based on your cluster topology

### Scaling Configuration
Adjust HPA settings in `autoscaling/horizontal-pod-autoscalers.yaml`:
- **Target Utilization**: Based on your performance requirements
- **Min/Max Replicas**: Based on your capacity and cost constraints
- **Scaling Policies**: Based on your traffic patterns

### Security Policies
Modify network policies in `network-policies/network-policies.yaml`:
- **Allowed Traffic**: Based on your application architecture
- **External Access**: Based on your security requirements
- **Namespace Isolation**: Based on your multi-tenancy needs

## Monitoring and Observability

### Health Endpoints
Applications should implement the following endpoints:
- `/health`: Liveness check endpoint
- `/ready`: Readiness check endpoint  
- `/metrics`: Prometheus metrics endpoint

### Metrics Collection
The manifests include annotations for Prometheus scraping:
```yaml
annotations:
  prometheus.io/scrape: "true"
  prometheus.io/port: "9090"
  prometheus.io/path: "/metrics"
```

### Logging
Applications should log to stdout/stderr for container log collection by:
- Fluentd/Fluent Bit
- Filebeat
- Promtail (for Loki)

## Troubleshooting

### Common Issues

1. **Pods Stuck in Pending**
   - Check resource requests vs available cluster capacity
   - Verify node affinity and anti-affinity rules
   - Check for node taints and tolerations

2. **HPA Not Scaling**
   - Verify metrics server is running
   - Check resource requests are defined
   - Validate custom metrics are available

3. **Network Policy Blocking Traffic**
   - Start with permissive policies and gradually restrict
   - Use `kubectl describe networkpolicy` to debug
   - Test connectivity with temporary debug pods

4. **Ingress Not Working**
   - Verify ingress controller is installed and running
   - Check ingress class annotations
   - Validate DNS resolution and TLS certificates

### Debugging Commands

```bash
# Check pod status and events
kubectl get pods -o wide
kubectl describe pod <pod-name>

# Check HPA status
kubectl get hpa
kubectl describe hpa <hpa-name>

# Check network policies
kubectl get networkpolicy
kubectl describe networkpolicy <policy-name>

# Check pod disruption budgets
kubectl get pdb
kubectl describe pdb <pdb-name>

# View resource usage
kubectl top pods
kubectl top nodes
```

## Security Considerations

### Network Security
- Default deny-all network policies are implemented
- Explicit allow rules for required communication
- Ingress traffic is restricted to ingress controllers
- Egress traffic is limited to necessary external services

### Container Security
- Containers run as non-root users
- Read-only root filesystems where possible
- Security contexts drop all capabilities
- No privilege escalation allowed

### RBAC
- Dedicated service accounts for each application
- Minimal required permissions
- Service account tokens are not auto-mounted

## Performance Optimization

### Resource Efficiency
- Resource requests match typical usage patterns
- Resource limits prevent resource starvation
- Ephemeral storage limits prevent disk space issues

### Scheduling Optimization
- Anti-affinity rules distribute load across nodes
- Node affinity prefers optimal node types
- Priority classes ensure critical workloads are scheduled first

### Scaling Efficiency
- HPA scaling policies balance responsiveness and stability
- Multiple metrics provide comprehensive scaling triggers
- Stabilization windows prevent thrashing

## Contributing

When modifying these manifests:

1. Test changes in a development environment first
2. Validate YAML syntax and Kubernetes API compatibility
3. Update documentation for any configuration changes
4. Consider backward compatibility for existing deployments
5. Follow security best practices and principle of least privilege