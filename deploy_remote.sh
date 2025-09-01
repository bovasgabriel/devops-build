#!/bin/bash
set -e

# Variables
APP_NAME=devops-build
IMAGE_NAME=bovasgabriel/dev:latest

echo "Pulling latest Docker image..."
docker pull $IMAGE_NAME

echo "Stopping and removing old container..."
docker rm -f $APP_NAME || true

echo "Starting new container..."
docker run -d --name $APP_NAME -p 80:80 $IMAGE_NAME

echo "Deployment completed!"
