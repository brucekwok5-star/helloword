#!/bin/bash
# End-to-End Test Script for Helloworld Application

set -e

NAMESPACE="prod"
APP_NAME="helloworld"
TIMEOUT=60

echo "========================================="
echo "Helloworld E2E Test Suite"
echo "========================================="

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

pass() { echo -e "${GREEN}✓ PASS${NC}: $1"; }
fail() { echo -e "${RED}✗ FAIL${NC}: $1"; exit 1; }
info() { echo -e "${YELLOW}ℹ INFO${NC}: $1"; }

# Test 1: Check pods are running
echo ""
info "Test 1: Checking pods status..."
PODS=$(kubectl get pods -n $NAMESPACE -l app=$APP_NAME -o jsonpath='{.items[*].status.phase}')
if echo "$PODS" | grep -q "Running"; then
    pass "Pods are running"
else
    fail "Pods are not running"
fi

# Test 2: Check all pods are ready
echo ""
info "Test 2: Checking pod readiness..."
READY=$(kubectl get pods -n $NAMESPACE -l app=$APP_NAME -o jsonpath='{.items[*].status.conditions[?(@.type=="Ready")].status}')
if echo "$READY" | grep -q "True"; then
    pass "Pods are ready"
else
    fail "Pods are not ready"
fi

# Test 3: Check deployment
echo ""
info "Test 3: Checking deployment..."
REPLICAS=$(kubectl get deployment $APP_NAME -n $NAMESPACE -o jsonpath='{.status.readyReplicas}')
if [ "$REPLICAS" -ge 1 ]; then
    pass "Deployment has $REPLICAS ready replicas"
else
    fail "Deployment has no ready replicas"
fi

# Test 4: Check service
echo ""
info "Test 4: Checking service..."
SERVICE=$(kubectl get svc $APP_NAME -n $NAMESPACE -o jsonpath='{.spec.type}')
if [ "$SERVICE" = "LoadBalancer" ] || [ "$SERVICE" = "ClusterIP" ]; then
    pass "Service exists (type: $SERVICE)"
else
    fail "Service not found"
fi

# Test 5: Test endpoint from pod
echo ""
info "Test 5: Testing endpoint from within pod..."
RESPONSE=$(kubectl exec -n $NAMESPACE deploy/$APP_NAME -- wget -q -O- http://localhost:8080/ 2>/dev/null)
if [ "$RESPONSE" = "Hello, Automatic Deploy!" ]; then
    pass "Endpoint returns correct message"
else
    fail "Endpoint returned: $RESPONSE"
fi

# Test 6: Test health endpoint
echo ""
info "Test 6: Testing health endpoint..."
HEALTH=$(kubectl exec -n $NAMESPACE deploy/$APP_NAME -- wget -q -O- http://localhost:8080/actuator/health 2>/dev/null)
if echo "$HEALTH" | grep -q "UP"; then
    pass "Health endpoint returns UP"
else
    fail "Health endpoint returned: $HEALTH"
fi

# Test 7: Test Prometheus metrics
echo ""
info "Test 7: Testing Prometheus metrics..."
METRICS=$(kubectl exec -n $NAMESPACE deploy/$APP_NAME -- wget -q -O- http://localhost:8080/actuator/prometheus 2>/dev/null)
if echo "$METRICS" | grep -q "jvm_"; then
    pass "Prometheus metrics available"
else
    fail "No JVM metrics found"
fi

# Test 8: Check PDB
echo ""
info "Test 8: Checking PodDisruptionBudget..."
PDB=$(kubectl get pdb $APP_NAME-pdb -n $NAMESPACE -o jsonpath='{.spec.minAvailable}' 2>/dev/null)
if [ "$PDB" = "1" ]; then
    pass "PodDisruptionBudget is set (minAvailable: $PDB)"
else
    info "PodDisruptionBudget not set or different value: $PDB"
fi

# Test 9: Check Prometheus targets
echo ""
info "Test 9: Checking Prometheus scraping..."
sleep 5
UP_METRICS=$(curl -s --get --data-urlencode "query=up{namespace=\"prod\",app=\"helloworld\",job=\"kubernetes-pods\"}" http://localhost:9090/api/v1/query 2>/dev/null || echo "")
if echo "$UP_METRICS" | grep -q '"value":\[.*,"1"'; then
    pass "Prometheus is scraping pods"
else
    fail "Prometheus is not scraping pods"
fi

# Test 10: Check Grafana dashboard
echo ""
info "Test 10: Checking Grafana dashboard..."
DASHBOARD=$(curl -s -u admin:"UzQXHwNLb3jwZVHHgdbwjAhZL2pqwvwbOidqbZxR" "http://localhost:3001/api/dashboards/uid/helloworld" 2>/dev/null || echo "")
if echo "$DASHBOARD" | grep -q "Helloworld Dashboard"; then
    pass "Grafana dashboard exists"
else
    fail "Grafana dashboard not found"
fi

echo ""
echo "========================================="
echo -e "${GREEN}All tests passed!${NC}"
echo "========================================="
