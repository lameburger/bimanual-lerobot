#!/bin/zsh
# LeRobot command aliases - source this in your .zshrc or run: source lerobot_aliases.sh

# Set the lerobot directory
export LEROBOT_DIR="/Users/laneburgett/lerobot"

# Aliases for common lerobot commands
alias lerobot-teleoperate='cd $LEROBOT_DIR && python lerobot/scripts/control_robot.py --control.type=teleoperate'
alias lerobot-calibrate='cd $LEROBOT_DIR && python lerobot/scripts/control_robot.py --control.type=calibrate'
alias lerobot-record='cd $LEROBOT_DIR && python lerobot/scripts/control_robot.py --control.type=record'
alias lerobot-find-port='cd $LEROBOT_DIR && python lerobot/scripts/find_motors_bus_port.py'
alias lerobot-configure-motor='cd $LEROBOT_DIR && python lerobot/scripts/configure_motor.py'
alias lerobot-train='cd $LEROBOT_DIR && python lerobot/scripts/train.py'
alias lerobot-eval='cd $LEROBOT_DIR && python lerobot/scripts/eval.py'

# Bimanual specific aliases
alias lerobot-bimanual='cd $LEROBOT_DIR && python lerobot/scripts/control_robot.py --robot.type=so101_bimanual --control.type=teleoperate'
alias lerobot-bimanual-calibrate='cd $LEROBOT_DIR && python lerobot/scripts/control_robot.py --robot.type=so101_bimanual --control.type=calibrate'

# Quick navigation
alias cdlerobot='cd $LEROBOT_DIR'

echo "✅ LeRobot aliases loaded!"
echo ""
echo "Available commands:"
echo "  lerobot-bimanual           - Run bimanual teleoperation"
echo "  lerobot-bimanual-calibrate - Calibrate bimanual setup"
echo "  lerobot-teleoperate        - Run teleoperation (add --robot.type=...)"
echo "  lerobot-calibrate          - Run calibration (add --robot.type=...)"
echo "  lerobot-record             - Record dataset"
echo "  lerobot-find-port          - Find motor bus port"
echo "  lerobot-train              - Train a policy"
echo "  lerobot-eval               - Evaluate a policy"
echo "  cdlerobot                  - Go to lerobot directory"
echo ""

