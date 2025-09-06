#!/bin/bash

# Loom Development Quality Check Script
# This script runs all quality checks locally before committing

set -e

echo "🚀 Running Loom Development Quality Checks..."
echo "=============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status
print_status() {
    local status=$1
    local message=$2
    if [ "$status" -eq 0 ]; then
        echo -e "${GREEN}✅ $message${NC}"
    else
        echo -e "${RED}❌ $message${NC}"
    fi
}

# Check if we're in the right directory
if [ ! -f "loom/pubspec.yaml" ]; then
    echo -e "${RED}❌ Error: Please run this script from the project root directory${NC}"
    exit 1
fi

cd loom

echo "📦 Installing Flutter dependencies..."
flutter pub get
print_status $? "Flutter dependencies installed"

echo "🔍 Running Flutter analyze..."
flutter analyze
print_status $? "Flutter analyze passed"

echo "🎨 Checking code formatting..."
if flutter format --dry-run --set-exit-if-changed . > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Code is properly formatted${NC}"
else
    echo -e "${YELLOW}⚠️  Code needs formatting. Run 'flutter format .' to fix.${NC}"
fi

echo "🧪 Running Flutter tests..."
flutter test
print_status $? "Flutter tests passed"

echo "🔧 Checking Rust code quality..."
cd ../rust

if [ -f "Cargo.toml" ]; then
    echo "📦 Installing Rust dependencies..."
    cargo check
    print_status $? "Rust dependencies checked"

    echo "🧪 Running Rust tests..."
    cargo test
    print_status $? "Rust tests passed"

    echo "🔍 Running Rust lints..."
    cargo clippy -- -D warnings
    print_status $? "Rust lints passed"

    echo "🎨 Checking Rust formatting..."
    cargo fmt --check
    print_status $? "Rust formatting correct"
else
    echo -e "${YELLOW}⚠️  No Rust code found, skipping Rust checks${NC}"
fi

cd ../loom

echo "📊 Generating test coverage..."
flutter test --coverage
print_status $? "Test coverage generated"

echo ""
echo "🎉 Quality checks completed!"
echo "=============================="
echo "If all checks passed, your code is ready for commit."
echo "Run 'git add .' and 'git commit' to commit your changes."
