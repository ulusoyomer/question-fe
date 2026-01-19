#!/bin/bash

# Navigate to the frontend directory relative to the script location
# This ensures the commands run from the root of the frontend project
cd "$(dirname "$0")/.." || exit

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Starting Code Generation ===${NC}"

# 1. Easy Localization Generator
# Generates LocaleKeys class from JSON files
echo -e "\n${GREEN}[1/2] Generating Localization Keys...${NC}"
if flutter pub run easy_localization:generate -S assets/translations -O lib/generated -o locale_keys.g.dart -f keys; then
    echo "Localization keys generated."
else
    echo "Error generating localization keys."
    exit 1
fi

# 2. Build Runner
# Handles AutoRoute, JsonSerializable, Freezed, etc.
echo -e "\n${GREEN}[2/2] Running Build Runner...${NC}"
if dart run build_runner build --delete-conflicting-outputs; then
    echo "Build runner completed."
else
    echo "Error running build_runner."
    exit 1
fi

echo -e "\n${BLUE}=== Generation Completed Successfully! ===${NC}"
