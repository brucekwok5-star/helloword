# Test Plan

## Overview
Comprehensive test strategy for helloworld application covering unit, integration, smoke, and E2E tests.

## Test Levels

### 1. Unit Tests
- **HelloControllerTest**: Test controller endpoints
- **Application Test**: Test Spring Boot application startup

### 2. Integration Tests
- **HealthEndpointTest**: Test actuator health endpoints
- **PrometheusMetricsTest**: Test Prometheus metrics exposure

### 3. Smoke Tests
- **Helm Test**: Validate deployment success
- **Kubernetes Resources**: Validate all resources are created

### 4. End-to-End Tests
- **Application Endpoint**: Test main endpoint returns correct response
- **Health Check**: Test liveness and readiness probes
- **Metrics**: Test Prometheus metrics are available
- **Network**: Test pod-to-pod connectivity

### 5. CI/CD Tests
- **Build Test**: Verify Docker image builds successfully
- **Security Scan**: Verify Trivy scan passes
- **Deploy Test**: Verify ArgoCD sync completes

## Test Execution

### Local
```bash
# Unit tests
mvn test

# Integration tests
mvn verify

# Helm tests
helm test helloworld
```

### CI/CD
- Pull request: Unit + Integration tests
- Main branch: Full pipeline + E2E tests

## Acceptance Criteria

- [ ] All unit tests pass
- [ ] All integration tests pass
- [ ] Helm test passes
- [ ] Application returns 200 OK
- [ ] Health endpoint returns UP
- [ ] Prometheus metrics available
- [ ] Both pods are healthy
