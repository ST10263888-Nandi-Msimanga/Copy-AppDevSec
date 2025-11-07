#!/bin/bash

# Script to fix out-of-sync package-lock.json files
# This regenerates all package-lock.json files to match package.json

set -e  # Exit on error

echo "🔧 Fixing package-lock.json files..."
echo ""

# Color output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to fix a component
fix_component() {
    local path=$1
    echo -e "${BLUE}→ Fixing $path${NC}"
    cd "$path"
    
    # Remove existing lock file and node_modules to ensure clean state
    rm -f package-lock.json
    
    # Regenerate lock file
    npm install --package-lock-only
    
    cd - > /dev/null
    echo -e "${GREEN}✓ $path fixed${NC}"
    echo ""
}

# Save current directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Fix all four components
fix_component "employee-portal/backend"
fix_component "employee-portal/frontend"
fix_component "payments-portal/backend"
fix_component "payments-portal/frontend"

echo -e "${GREEN}✅ All package-lock.json files have been regenerated!${NC}"
echo ""
echo "Next steps:"
echo "  1. Review the changes: git status"
echo "  2. Commit the changes: git add */*/package-lock.json"
echo "  3. Commit: git commit -m 'Fix: Regenerate package-lock.json files'"
echo "  4. Push: git push"
echo ""
echo "Then the GitHub Actions workflow will run successfully! 🚀"

