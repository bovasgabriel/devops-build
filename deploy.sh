#!/bin/bash

# Docker image name
IMAGE_NAME="bovasgabriel/dev:latest"

# Log in to Docker Hub
sudo docker login -u bovasgabriel

# Push Docker image
echo "Pushing Docker image: $IMAGE_NAME"
sudo docker push $IMAGE_NAME

if [ $? -eq 0 ]; then
  echo "Image pushed successfully to Docker Hub."
else
  echo "Image push failed. Please check the errors above."
  exit 1
fi

# Deploy the container on port 80
sudo docker stop dev-app || true
sudo docker rm dev-app || true
sudo docker run -d -p 80:80 --name dev-app $IMAGE_NAME

echo "Deployment complete."

