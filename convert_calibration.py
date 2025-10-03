#!/usr/bin/env python3
"""Convert old-style calibration files to new format with motor_names list."""

import json
from pathlib import Path

# Motor order (important!)
MOTOR_ORDER = ["shoulder_pan", "shoulder_lift", "elbow_flex", "wrist_flex", "wrist_roll", "gripper"]

def convert_calibration(old_calib_path: Path, new_calib_path: Path):
    """Convert old dict-per-motor format to new array format."""
    
    with open(old_calib_path, 'r') as f:
        old_data = json.load(f)
    
    # Extract data in correct motor order
    homing_offset = []
    drive_mode = []
    start_pos = []  # This will be "range_min" in old format
    end_pos = []    # This will be "range_max" in old format
    calib_mode = []
    
    for motor_name in MOTOR_ORDER:
        motor_data = old_data[motor_name]
        homing_offset.append(motor_data["homing_offset"])
        drive_mode.append(motor_data["drive_mode"])
        start_pos.append(motor_data["range_min"])
        end_pos.append(motor_data["range_max"])
        
        # Gripper is LINEAR, others are DEGREE
        if motor_name == "gripper":
            calib_mode.append("LINEAR")
        else:
            calib_mode.append("DEGREE")
    
    # Create new format
    new_data = {
        "homing_offset": homing_offset,
        "drive_mode": drive_mode,
        "start_pos": start_pos,
        "end_pos": end_pos,
        "calib_mode": calib_mode,
        "motor_names": MOTOR_ORDER
    }
    
    # Save to new file
    with open(new_calib_path, 'w') as f:
        json.dump(new_data, f, indent=2)
    
    print(f"✅ Converted {old_calib_path.name} -> {new_calib_path.name}")

if __name__ == "__main__":
    calib_dir = Path(".cache/calibration/so101_bimanual")
    
    files_to_convert = [
        "left_follower.json",
        "right_follower.json", 
        "left_leader.json",
        "right_leader.json"
    ]
    
    for filename in files_to_convert:
        filepath = calib_dir / filename
        if filepath.exists():
            # Convert in place (backup original first)
            backup = calib_dir / f"{filename}.bak"
            filepath.rename(backup)
            convert_calibration(backup, filepath)
        else:
            print(f"⚠️  File not found: {filepath}")
    
    print("\n✅ All calibration files converted!")


