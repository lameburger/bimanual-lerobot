#!/bin/bash
# Setup script for LeRobot - makes all commands work properly

echo "🤖 Setting up LeRobot environment..."
echo ""

# Get the directory where this script is located
LEROBOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if lerobot conda environment exists
if conda env list | grep -q "^lerobot "; then
    echo "✅ Found lerobot conda environment"
    
    # Activate it
    eval "$(conda shell.bash hook)"
    conda activate lerobot
    
    echo "✅ Activated lerobot environment"
    python --version
    echo ""
    
    # Install package in editable mode from source
    echo "📦 Installing lerobot package from source..."
    cd "$LEROBOT_DIR"
    pip install -e ".[feetech]" --no-deps 2>&1 | grep -v "Requirement already satisfied" || true
    
    if [ $? -eq 0 ]; then
        echo "✅ Package installed successfully"
        echo ""
        echo "🎉 Setup complete! Available commands:"
        echo "   • python lerobot/scripts/control_robot.py --robot.type=so101_bimanual --control.type=teleoperate"
        echo "   • python lerobot/scripts/find_motors_bus_port.py"
        echo ""
        echo "💡 To keep this environment active, run:"
        echo "   source setup_lerobot.sh"
    else
        echo "⚠️  Installation had issues. Trying without dependencies..."
        pip install -e . --no-deps
    fi
else
    echo "❌ lerobot conda environment not found!"
    echo ""
    echo "Creating new lerobot environment with Python 3.10..."
    conda create -n lerobot python=3.10 -y
    
    eval "$(conda shell.bash hook)"
    conda activate lerobot
    
    cd "$LEROBOT_DIR"
    pip install -e ".[feetech]"
    
    echo "✅ New environment created and package installed"
fi

echo ""
echo "Current environment: $CONDA_DEFAULT_ENV"
echo "Python: $(which python)"


