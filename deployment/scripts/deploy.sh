#!/bin/bash

# Deployment script for EngageSense

# Environment validation
if [ -z "$DEPLOY_ENV" ]; then
  echo "Error: DEPLOY_ENV not set"
  exit 1
fi

# Load environment variables
source .env.$DEPLOY_ENV

# Build validation
echo "Running pre-deployment checks..."
npm run lint || exit 1
npm run test || exit 1

# Build application
echo "Building application for $DEPLOY_ENV..."
npm run build

# Deploy to Netlify
echo "Deploying to Netlify..."
netlify deploy --prod

# Post-deployment checks
echo "Running post-deployment checks..."
curl -s "$VITE_API_URL/health" || exit 1

echo "Deployment complete!"