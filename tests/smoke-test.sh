#!/bin/bash
# Smoke Test - Quick validation of key components

set -e

NAMESPACE="prod"
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

pass() { echo -e "${GREEN}✓${NC} $1"; }
fail() { echo -e "${RED}✗${NC} $1"; exit 1; }

echo "Running Smoke Tests..."

# 1. Check pods
kubectl get pods -n $NAMESPACE -l app=helloworld | grep -q Running || fail "Pods not running"
pass "Pods running"

# 2. Check service
kubectl get svc -n $NAMESPACE helloworld -o jsonpath='{.spec.type}' | grep -qE "LoadBalancer|ClusterIP" || fail "Service missing"
pass "Service exists"

# 3. Quick endpoint test
kubectl exec -n $NAMESPACE deploy/helloworld -- wget -q -O- http://localhost:8080/ | grep -q "Hello" || fail "Endpoint failed"
pass "Endpoint responding"

# 4. Health check
kubectl exec -n $NAMESPACE deploy/helloworld -- wget -q -O- http://localhost:8080/actuator/health | grep -q UP || fail "Health check failed"
pass "Health OK"

echo ""
echo "Smoke tests passed!"
