#!/bin/bash

IMAGE_NAME="bovasgabriel/dev:latest"

echo "Pushing Docker image: $IMAGE_NAME"
sudo docker push $IMAGE_NAME

if [ $? -eq 0 ]; then
  echo "Image pushed successfully to Docker Hub."
else
  echo "Image push failed. Please check the errors above."
  exit 1
fi

