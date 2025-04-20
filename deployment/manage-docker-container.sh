#!/bin/bash

# Default values
MODE=""
APP_NAME=""
CURRENT_APP_VERSION=""
PREVIOUS_APP_VERSION=""

# Parse arguments
for ARG in "$@"
do
  case $ARG in
    --mode=*)
      MODE="${ARG#*=}"
      shift
      ;;
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
      echo "Usage: $0 --mode=cannary|full --app-name=xxx --app-version=2.xxx --app-previous-version=1.xxx"
      exit 1
      ;;
  esac
done

# Validate parameters
if [ -z "$MODE" ] || [ -z "$APP_NAME" ] || [ -z "$CURRENT_APP_VERSION" ] || [ -z "$PREVIOUS_APP_VERSION" ]; then
  echo "❌ Error: All four parameters are required."
  echo "Usage: $0 --mode=cannary|full --app-name=xxx --app-version=2.xxx --app-previous-version=1.xxx"
  exit 1
fi

# Decide which script to run
case "$MODE" in
  cannary)
    echo "🟡 Running Canary Deployment..."
    ./docker-cannary.sh --app-name="$APP_NAME" --app-version="$CURRENT_APP_VERSION" --app-previous-version="$PREVIOUS_APP_VERSION"
    ;;
  full)
    echo "🟢 Running Full Deployment..."
    ./docker-full.sh --app-name="$APP_NAME" --app-version="$CURRENT_APP_VERSION" --app-previous-version="$PREVIOUS_APP_VERSION"
    ;;
  *)
    echo "❌ Error: Invalid mode. Choose either 'cannary' or 'full'."
    exit 1
    ;;
esac
