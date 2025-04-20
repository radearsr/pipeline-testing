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

# Show current Docker containers before deployment
echo -e "\n🚢 Current Docker containers (before):"
docker ps -a
echo "-------------------------------------"

# Run docker-compose full version (no stop, just create instance 3 & 4)
echo -e "\n🚀 Deploying additional instances (instance 3 and 4)..."
docker-compose -f docker-compose.full.yml up -d --no-recreate

# Show current Docker containers after deployment
echo -e "\n🚢 Current Docker containers (after):"
docker ps -a
echo "-------------------------------------"
