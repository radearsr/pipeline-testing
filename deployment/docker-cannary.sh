#!/bin/bash

# Default values
APP_NAME=""
CURRENT_APP_VERSION=""
PREVIOUS_APP_VERSION=""

# Parse long arguments
for ARG in "$@"
do
  case $ARG in
    --app-name=*)
      APP_NAME="${ARG#*=}"
      shift
      ;;
    --app-version=*)
      CURRENT_APP_VERSION="${ARG#*=}"
      shift
      ;;
    --app-previous-version=*)
      PREVIOUS_APP_VERSION="${ARG#*=}"
      shift
      ;;
    *)
      echo "Unknown option: $ARG"
      echo "Usage: $0 --app-name=xxx --app-version=2.xxx --app-previous-version=1.xxx"
      exit 1
      ;;
  esac
done

# Check if all required parameters are provided
if [ -z "$APP_NAME" ] || [ -z "$CURRENT_APP_VERSION" ] || [ -z "$PREVIOUS_APP_VERSION" ]; then
  echo "❌ Error: All three parameters are required."
  echo "Usage: $0 --app-name=xxx --app-version=2.xxx --app-previous-version=1.xxx"
  exit 1
fi

# Export variables to environment
export APP_NAME
export CURRENT_APP_VERSION
export PREVIOUS_APP_VERSION

echo "✅ Environment variables set:"
echo "APP_NAME=$APP_NAME"
echo "CURRENT_APP_VERSION=$CURRENT_APP_VERSION"
echo "PREVIOUS_APP_VERSION=$PREVIOUS_APP_VERSION"

# Show current Docker images
echo -e "\n📦 Current Docker images:"
docker images
echo "-------------------------------------"

# Show current Docker containers
echo -e "\n🚢 Current Docker containers:"
docker ps -a
echo "-------------------------------------"

# Stopping instace 1 and 2 
echo -e "\n🛑 Stopping instance 1 and 2..."
docker stop ${APP_NAME}_v${PREVIOUS_APP_VERSION}_instance_1
docker stop ${APP_NAME}_v${PREVIOUS_APP_VERSION}_instance_2
docker rm ${APP_NAME}_v${PREVIOUS_APP_VERSION}_instance_1
docker rm ${APP_NAME}_v${PREVIOUS_APP_VERSION}_instance_2
echo "-------------------------------------"

# Run docker-compose
echo -e "\n🚀 Running Docker Compose with Canary Deployment..."
docker-compose -f docker-compose.cannary.yml up -d

# Show current Docker containers after deployment
echo -e "\n🚢 Current Docker containers after deployment:
docker ps -a
echo "-------------------------------------"
