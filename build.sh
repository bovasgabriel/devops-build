#!/bin/bash

IMAGE_NAME="bovasgabriel/dev:latest"

echo "Building Docker image: $IMAGE_NAME"
sudo docker build -t $IMAGE_NAME .

if [ $? -eq 0 ]; then
  echo "Build complete. Run ./deploy.sh to push the image."
else
  echo "Build failed. Please check the errors above."
  exit 1
fi

