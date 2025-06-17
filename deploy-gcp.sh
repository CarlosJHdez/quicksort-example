#!/bin/bash

# Google Cloud Deployment Script for Quicksort Example
# This script automates the deployment process to Google Kubernetes Engine (GKE)

set -e  # Exit on any error

# Configuration
PROJECT_ID="${1:-quicksort-example-alpha}"
REGION="${2:-us-central1}"
CLUSTER_NAME="${3:-quicksort-cluster}"
IMAGE_NAME="gcr.io/${PROJECT_ID}/quicksort-example:latest"

echo "🚀 Starting Google Cloud deployment for Quicksort Example"
echo "Project ID: ${PROJECT_ID}"
echo "Region: ${REGION}"
echo "Cluster: ${CLUSTER_NAME}"
echo "Image: ${IMAGE_NAME}"

# Check if required tools are installed
command -v gcloud >/dev/null 2>&1 || { echo "❌ gcloud CLI is required but not installed. Aborting." >&2; exit 1; }
command -v kubectl >/dev/null 2>&1 || { echo "❌ kubectl is required but not installed. Aborting." >&2; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "❌ Docker is required but not installed. Aborting." >&2; exit 1; }

echo "✅ All required tools are installed"

# Step 1: Configure gcloud and enable required services
echo "📋 Configuring Google Cloud..."
gcloud config set project ${PROJECT_ID}
gcloud services enable container.googleapis.com
gcloud services enable containerregistry.googleapis.com

# Step 2: Build and push Docker image
echo "🔨 Building Docker image for Linux/AMD64 platform..."
docker build --platform linux/amd64 -t ${IMAGE_NAME} .

echo "📤 Pushing image to Google Container Registry..."
gcloud auth configure-docker
docker push ${IMAGE_NAME}

# Step 3: Check for existing cluster or create new one
echo "🏗️  Setting up GKE cluster..."
if gcloud container clusters describe ${CLUSTER_NAME} --region=${REGION} >/dev/null 2>&1; then
    echo "✅ Using existing cluster: ${CLUSTER_NAME}"
else
    echo "🔍 No existing cluster found. Creating new cluster..."
    echo "💡 If you encounter quota issues, you can:"
    echo "   1. Request quota increase at: https://console.cloud.google.com/iam-admin/quotas"
    echo "   2. Use a different region with more available quota"
    echo "   3. Try an existing cluster (quicksort-autopilot, quicksort-cluster, etc.)"
    echo ""
    
    # Try creating with Autopilot first (lowest resource requirements)
    echo "🆕 Creating Autopilot cluster (recommended for lower quotas)..."
    if ! gcloud container clusters create-auto ${CLUSTER_NAME} --region=${REGION}; then
        echo "❌ Autopilot cluster creation failed. Trying standard cluster..."
        
        # Fallback to standard cluster with minimal resources
        gcloud container clusters create ${CLUSTER_NAME} \
            --region=${REGION} \
            --machine-type=e2-small \
            --disk-size=30GB \
            --disk-type=pd-standard \
            --num-nodes=1 \
            --enable-autoscaling \
            --min-nodes=1 \
            --max-nodes=2 \
            --enable-autorepair \
            --enable-autoupgrade \
            --enable-ip-alias \
            --no-enable-basic-auth \
            --no-issue-client-certificate
    fi
fi

# Step 4: Get cluster credentials
echo "🔑 Getting cluster credentials..."
if ! gcloud container clusters get-credentials ${CLUSTER_NAME} --region=${REGION}; then
    echo "❌ Failed to get cluster credentials. Check cluster status and try again."
    exit 1
fi

# Verify cluster connection
echo "🔍 Verifying cluster connection..."
if ! kubectl cluster-info &>/dev/null; then
    echo "❌ Cannot connect to cluster. Check your credentials and cluster status."
    exit 1
fi

# Step 5: Update Kubernetes manifests with correct project ID
echo "📝 Updating Kubernetes manifests..."
sed -i.bak "s/PROJECT_ID/${PROJECT_ID}/g" k8s/test-job.yaml
sed -i.bak "s/PROJECT_ID/${PROJECT_ID}/g" k8s/demo-job.yaml

# Step 6: Deploy to Kubernetes
echo "🚀 Deploying to Kubernetes..."
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/service.yaml

# Clean up any existing jobs first
echo "🧹 Cleaning up existing jobs..."
kubectl delete job quicksort-demo-job -n quicksort-example --ignore-not-found=true || echo "  No existing demo job found"
kubectl delete job quicksort-test-job -n quicksort-example --ignore-not-found=true || echo "  No existing test job found"

# Step 7: Run demo and tests
echo "🎯 Running quicksort demo..."
kubectl apply -f k8s/demo-job.yaml

echo "🧪 Running tests in Kubernetes..."
kubectl apply -f k8s/test-job.yaml

# Step 8: Wait for completion and show status
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

echo "📊 Deployment status:"
kubectl get jobs -n quicksort-example
kubectl get pods -n quicksort-example
kubectl get services -n quicksort-example

echo ""
echo "� Results:"
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
echo "✅ Deployment completed!"

# Step 9: Get service URL
echo "🌐 Service information:"
kubectl get service quicksort-app-loadbalancer -n quicksort-example

echo "✅ Deployment completed successfully!"
echo ""
echo "📋 Next steps:"
echo "1. Check demo results: kubectl logs job/quicksort-demo-job -n quicksort-example"
echo "2. Check test results: kubectl logs job/quicksort-test-job -n quicksort-example"
echo "3. Run demo again: kubectl delete job quicksort-demo-job -n quicksort-example && kubectl apply -f k8s/demo-job.yaml"
echo ""
echo "🔧 Useful commands:"
echo "- View jobs: kubectl get jobs -n quicksort-example"
echo "- View pods: kubectl get pods -n quicksort-example"
echo "- View demo logs: kubectl logs job/quicksort-demo-job -n quicksort-example"
echo "- View test logs: kubectl logs job/quicksort-test-job -n quicksort-example"
echo "- Delete deployment: kubectl delete namespace quicksort-example"
