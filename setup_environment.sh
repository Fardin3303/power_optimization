#!/bin/bash
# Rivervault Crisis - Environment Setup Script
# This script creates a virtual environment and installs required packages

echo "🧙‍♂️ Rivervault Crisis: Environment Setup"
echo "=========================================="
echo ""

# Check if Python is available
if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 is not installed. Please install Python 3.7 or higher."
    exit 1
fi

echo "✅ Python3 found: $(python3 --version)"
echo ""

# Remove existing venv if present
if [ -d ".venv" ]; then
    echo "🗑️  Removing existing virtual environment..."
    rm -rf .venv
    echo ""
fi

# Create virtual environment
echo "📦 Creating virtual environment..."
python3 -m venv .venv

if [ $? -ne 0 ]; then
    echo "❌ Failed to create virtual environment"
    exit 1
fi

echo "✅ Virtual environment created"
echo ""

# Activate virtual environment
echo "🔌 Activating virtual environment..."
source .venv/bin/activate

# Upgrade pip
echo "⬆️  Upgrading pip..."
pip install --upgrade pip --quiet

# Install required packages
echo "📥 Installing required packages..."
echo "   - pandas (data analysis)"
echo "   - matplotlib (visualization)"
echo "   - PuLP (linear programming)"
echo ""

pip install pandas matplotlib pulp --quiet

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ All packages installed successfully!"
    echo ""
    echo "═══════════════════════════════════════════════════════════"
    echo "🎉 Setup Complete!"
    echo "═══════════════════════════════════════════════════════════"
    echo ""
    echo "📝 Next steps:"
    echo "   1. Activate the virtual environment:"
    echo "      source .venv/bin/activate"
    echo ""
    echo "   2. Open the notebook:"
    echo "      jupyter notebook rivervault_crisis_optimization.ipynb"
    echo ""
    echo "   Or use VS Code to open:"
    echo "      code rivervault_crisis_optimization.ipynb"
    echo ""
    echo "💡 The notebook will automatically use this virtual environment"
    echo "   when you select the Python interpreter from .venv/bin/python"
    echo ""
else
    echo ""
    echo "❌ Failed to install packages"
    exit 1
fi
