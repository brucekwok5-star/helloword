# Hello World Application

A production-ready Spring Boot application deployed to Kubernetes using GitOps.

## Architecture

- **Application**: Spring Boot 3.2.0 with Java 17
- **Container**: Multi-platform Docker image (amd64/arm64)
- **Orchestration**: Kubernetes (Kind)
- **GitOps**: ArgoCD
- **Monitoring**: Prometheus + Grafana + Loki
- **CI/CD**: GitHub Actions

## Features

- Health endpoints (`/actuator/health`, `/actuator/prometheus`)
- Prometheus metrics collection
- OpenAPI/Swagger documentation (`/swagger-ui.html`)
- Graceful shutdown
- Liveness and readiness probes
- Network policies
- PodDisruptionBudget for HA
- Security scanning (Trivy)
- Image signing (Cosign)
- SBOM generation

## Quick Start

### Local Development

```bash
# Build the application
mvn clean package

# Run locally
java -jar target/helloworld-1.0.0.jar
```

### Docker

```bash
# Build
docker build -t helloworld .

# Run
docker run -p 8080:8080 helloworld
```

### Deploy to Kind Cluster

```bash
# Create cluster
kind create cluster --name helloworld

# Install ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Install application
argocd app create helloworld-prod \
  --repo https://github.com/brucekwok5-star/helloword.git \
  --path helm-chart \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace prod \
  --helm-set image.tag=latest
```

## CI/CD Pipeline

The GitHub Actions workflow includes:

1. **Test** - Runs unit tests
2. **Lint** - Checkstyle validation
3. **Build** - Multi-platform Docker build
4. **Security** - Trivy vulnerability scan
5. **Sign** - Cosign image signing
6. **SBOM** - Software Bill of Materials
7. **Deploy** - ArgoCD sync

## Monitoring

### Access Grafana

```bash
kubectl port-forward -n monitoring svc/grafana 3000:80
```

- URL: http://localhost:3000
- Username: admin
- Password: (see monitoring values)

### Access Prometheus

```bash
kubectl port-forward -n monitoring svc/prometheus-server 9090:80
```

### Access ArgoCD

```bash
kubectl port-forward -n argocd svc/argocd-server 8081:443
```

- URL: https://localhost:8081
- Username: admin
- Password: (see ArgoCD secret)

## Endpoints

| Endpoint | Description |
|----------|-------------|
| `/` | Main hello endpoint |
| `/actuator/health` | Health check |
| `/actuator/prometheus` | Prometheus metrics |
| `/actuator/info` | Application info |
| `/swagger-ui.html` | API documentation |
| `/api-docs` | OpenAPI JSON |

## Alerts

Prometheus alerts configured:

- `HelloworldDown` - App is down
- `HelloworldHighMemoryUsage` - Memory > 85%
- `HelloworldHighCpuUsage` - CPU > 80%
- `HelloworldPodRestartingTooMuch` - > 3 restarts/hour
- `HelloworldNotReady` - Pod not ready

## Network Policies

The application uses network policies to restrict traffic:

- Ingress: Only from ArgoCD, Prometheus, same namespace
- Egress: DNS only

## TLS Configuration

TLS can be enabled by:

1. Creating a TLS secret:
```bash
kubectl create secret tls helloworld-tls \
  --cert=certificate.crt \
  --key=private.key
```

2. Enabling TLS in values:
```yaml
tls:
  enabled: true
  secretName: helloworld-tls
```

## Development with Skaffold

```bash
# Install Skaffold
brew install skaffold

# Run in development mode
skaffold dev --profile dev
```

## Pre-commit Hooks

Install pre-commit hooks:

```bash
pip install pre-commit
pre-commit install
```

## Security

- Trivy scans for vulnerabilities
- Cosign signs images
- SBOM generated for each build
- Network policies restrict access
- Non-root user in container
