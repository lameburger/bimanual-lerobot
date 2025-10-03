#!/bin/bash
# Installation script for LeRobot development version with bimanual support

echo "Installing LeRobot from source with Feetech support..."
echo "This requires Python >= 3.10"
echo ""

# Check if in conda environment
if [[ -z "$CONDA_DEFAULT_ENV" ]]; then
    echo "WARNING: No conda environment detected."
    echo "Please activate the lerobot environment first:"
    echo "  conda activate lerobot"
    exit 1
fi

# Check Python version
python_version=$(python --version 2>&1 | awk '{print $2}')
echo "Current Python version: $python_version"
echo "Current conda environment: $CONDA_DEFAULT_ENV"
echo ""

# Uninstall old version
echo "Uninstalling any existing lerobot package..."
pip uninstall lerobot -y 2>/dev/null

# Install in development mode
echo ""
echo "Installing lerobot in development mode with feetech support..."
pip install -e ".[feetech]"

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Installation successful!"
    echo ""
    echo "You can now run bimanual teleoperation with:"
    echo "  python lerobot/scripts/control_robot.py --robot.type=so101_bimanual --control.type=teleoperate"
else
    echo ""
    echo "❌ Installation failed. Check the error messages above."
    echo ""
    echo "Common issues:"
    echo "  - Python version < 3.10 (you have $python_version)"
    echo "  - Conda environment not activated"
    echo "  - Missing system dependencies"
fi



