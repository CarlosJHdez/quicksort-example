#!/bin/bash

# Simple deployment script for existing clusters
# Use this when you already have a cluster set up

set -e

PROJECT_ID="${1:-quicksort-example-alpha}"
CLUSTER_NAME="${2:-quicksort-autopilot}"
REGION="${3:-us-central1}"

echo "🚀 Quick deployment to existing cluster"
echo "Project: ${PROJECT_ID}"
echo "Cluster: ${CLUSTER_NAME}"
echo "Region: ${REGION}"

# Get cluster credentials
echo "🔑 Getting cluster credentials..."
if ! gcloud container clusters get-credentials ${CLUSTER_NAME} --region=${REGION} --project=${PROJECT_ID}; then
    echo "❌ Failed to get cluster credentials. Make sure the cluster exists and you have access."
    exit 1
fi

# Verify cluster connection
echo "🔍 Verifying cluster connection..."
if ! kubectl cluster-info &>/dev/null; then
    echo "❌ Cannot connect to cluster. Check your credentials and cluster status."
    exit 1
fi

# Ensure namespace exists first
echo "🏗️  Ensuring namespace exists..."
kubectl apply -f k8s/namespace.yaml

# Update manifests
echo "📝 Updating Kubernetes manifests..."
sed -i.bak "s/PROJECT_ID/${PROJECT_ID}/g" k8s/demo-job.yaml k8s/test-job.yaml

# Clean up any existing jobs (more robust approach)
echo "🧹 Cleaning up existing jobs..."
echo "  Deleting quicksort-demo-job if it exists..."
kubectl delete job quicksort-demo-job -n quicksort-example --ignore-not-found=true || echo "  No existing demo job found"
echo "  Deleting quicksort-test-job if it exists..."
kubectl delete job quicksort-test-job -n quicksort-example --ignore-not-found=true || echo "  No existing test job found"

# Deploy service if needed
echo "🚀 Ensuring service exists..."
kubectl apply -f k8s/service.yaml

# Run demo and tests
echo "🎯 Running quicksort demo..."
kubectl apply -f k8s/demo-job.yaml

echo "🧪 Running tests..."
kubectl apply -f k8s/test-job.yaml

# Wait for completion
echo "⏳ Waiting for jobs to complete..."
echo "  Waiting for demo job..."
if ! kubectl wait --for=condition=complete --timeout=300s job/quicksort-demo-job -n quicksort-example; then
    echo "⚠️  Demo job didn't complete within timeout. Checking status..."
    kubectl get job quicksort-demo-job -n quicksort-example || echo "Demo job not found"
fi

echo "  Waiting for test job..."
if ! kubectl wait --for=condition=complete --timeout=300s job/quicksort-test-job -n quicksort-example; then
    echo "⚠️  Test job didn't complete within timeout. Checking status..."
    kubectl get job quicksort-test-job -n quicksort-example || echo "Test job not found"
fi

echo "✅ Job execution finished!"
echo ""
echo "📊 Results:"
echo "🎯 Demo output:"
if kubectl get job quicksort-demo-job -n quicksort-example &>/dev/null; then
    kubectl logs job/quicksort-demo-job -n quicksort-example || echo "No logs available for demo job"
else
    echo "Demo job not found"
fi

echo ""
echo "🧪 Test results:"
if kubectl get job quicksort-test-job -n quicksort-example &>/dev/null; then
    kubectl logs job/quicksort-test-job -n quicksort-example | tail -1 || echo "No logs available for test job"
else
    echo "Test job not found"
fi

echo ""
echo "🔧 Useful commands:"
echo "- View all jobs: kubectl get jobs -n quicksort-example"
echo "- View demo logs: kubectl logs job/quicksort-demo-job -n quicksort-example"
echo "- View test logs: kubectl logs job/quicksort-test-job -n quicksort-example"
echo "- Run again: ./run-jobs.sh ${PROJECT_ID} ${CLUSTER_NAME} ${REGION}"
