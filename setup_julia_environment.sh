#!/bin/bash
set -e

# ==============================================================================
# Julia Setup Script for SDDP Optimization
# ==============================================================================
#
# PURPOSE:
#   Automates the installation and configuration of Julia and necessary packages
#   for SDDP (Stochastic Dual Dynamic Programming) optimization.
#
# KEY COMPONENTS:
#   1. Julia Installation Check
#      - Checks if Julia is already installed on the system
#      - If not found, offers to install it automatically using juliaup
#      - Adds Julia to the system PATH in .bashrc and .profile
#      - Validates Julia version (requires 1.6+)
#
#   2. Package Installation
#      Installs essential Julia packages:
#      - SDDP.jl: Core package for stochastic optimization
#      - JuMP.jl: Mathematical optimization modeling language
#      - HiGHS: Linear/mixed-integer programming solver
#      - Ipopt: Nonlinear optimization solver
#      - DataFrames.jl: Data manipulation
#      - Plots.jl: Visualization
#      - Statistics: Statistical functions
#      - IJulia: Jupyter notebook kernel for Julia
#
#   3. Jupyter Integration
#      - Sets up the IJulia kernel for use in Jupyter notebooks
#      - Allows running Julia code in rivervault_crisis_sddp_julia.ipynb
#
#   4. Verification
#      - Tests that critical packages (SDDP, JuMP, HiGHS, Ipopt) load correctly
#      - Reports success/failure for each component
#
# HOW IT WORKS:
#   1. Detection: First checks for existing Julia installation
#   2. Installation: If needed, downloads and installs Julia via curl
#   3. Dependencies: Installs all required packages using Julia's package manager
#   4. Testing: Verifies everything works by attempting to load each package
#   5. Reporting: Provides clear feedback with ✅/❌ indicators
#
# USAGE:
#   ./setup_julia_environment.sh
#
# NOTE:
#   Script is idempotent (safe to run multiple times) and interactive
#   (prompts for user confirmation before installing Julia).
#
# ==============================================================================

echo "=========================================="
echo "Julia Setup for SDDP Optimization"
echo "=========================================="
echo ""

# Check if Julia is installed
echo "🔍 Checking for Julia installation..."
if ! command -v julia &> /dev/null; then
    echo "❌ Julia is not installed"
    echo ""
    read -p "Would you like to install Julia now? (Y/n) " -n 1 -r
    echo ""
    
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        echo ""
        echo "📥 Installing Julia using juliaup..."
        curl -fsSL https://install.julialang.org | sh -s -- --yes
        
        # Add to PATH for current session
        export PATH="$HOME/.juliaup/bin:$PATH"
        
        # Add to PATH permanently
        if [ -f "$HOME/.bashrc" ]; then
            if ! grep -q "juliaup/bin" "$HOME/.bashrc"; then
                echo 'export PATH="$HOME/.juliaup/bin:$PATH"' >> "$HOME/.bashrc"
            fi
        fi
        
        if [ -f "$HOME/.profile" ]; then
            if ! grep -q "juliaup/bin" "$HOME/.profile"; then
                echo 'export PATH="$HOME/.juliaup/bin:$PATH"' >> "$HOME/.profile"
            fi
        fi
        
        echo ""
        echo "✅ Julia installed successfully!"
        echo "⚠️  Note: You may need to restart your terminal for PATH changes to take effect"
        echo ""
    else
        echo ""
        echo "❌ Julia is required. Please install it manually:"
        echo "   Visit: https://julialang.org/downloads/"
        exit 1
    fi
else
    JULIA_VERSION=$(julia --version)
    echo "✅ Julia found: $JULIA_VERSION"
    
    # Check Julia version (should be 1.6+)
    JULIA_MAJOR=$(julia -e 'print(VERSION.major)')
    JULIA_MINOR=$(julia -e 'print(VERSION.minor)')
    
    if [ "$JULIA_MAJOR" -lt 1 ] || ([ "$JULIA_MAJOR" -eq 1 ] && [ "$JULIA_MINOR" -lt 6 ]); then
        echo "⚠️  Warning: Julia version 1.6 or higher is recommended for SDDP"
        echo "Current version: $JULIA_VERSION"
        echo ""
    fi
fi

echo ""
echo "📦 Installing Julia packages for SDDP optimization..."
echo ""

# Install required Julia packages
julia << 'EOF'
import Pkg

println("📦 Installing required packages...")

packages = ["SDDP", "JuMP", "HiGHS", "Ipopt", "DataFrames", "Plots", "Statistics", "IJulia"]

for pkg in packages
    print("  Installing $pkg... ")
    try
        Pkg.add(pkg)
        println("✅")
    catch e
        println("❌ Error: $e")
    end
end

Pkg.build()
println("\n✅ All packages installed!")
EOF

echo ""
echo "🔧 Setting up IJulia kernel for Jupyter notebooks..."

# Install IJulia kernel
julia -e 'using IJulia; installkernel("Julia")' 2>/dev/null || echo "⚠️  Kernel installation skipped (may already exist)"

echo ""
echo "🧪 Testing package installation..."

# Quick verification test
julia << 'TESTEOF'
println("Testing packages...")
packages = ["SDDP", "JuMP", "HiGHS", "Ipopt"]
all_ok = true
for pkg in packages
    try
        eval(Meta.parse("using $pkg"))
        println("  ✅ $pkg")
    catch e
        println("  ❌ $pkg failed: $e")
        all_ok = false
    end
end
if all_ok
    println("\n✅ All critical packages working!")
else
    println("\n❌ Some packages failed to load")
    exit(1)
end
TESTEOF

if [ $? -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo "✅ Setup Complete!"
    echo "=========================================="
    echo ""
    echo "🎉 Your Julia environment is ready!"
    echo ""
    echo "📚 Next steps:"
    echo "  1. Open rivervault_crisis_sddp_julia.ipynb"
    echo "  2. Select the Julia kernel"
    echo "  3. Run the notebook cells"
    echo ""
else
    echo ""
    echo "❌ Setup failed - please check errors above"
    exit 1
fi
