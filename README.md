# SO-101 Bimanual Teleoperation

Control two SO-101 arms simultaneously with bimanual teleoperation.

## Quick Start

### 1. Install Dependencies

```bash
pip install -e ".[feetech]"
```

### 2. Load Aliases (Optional but Recommended)

```bash
source lerobot_aliases.sh
```

Or add to your `~/.zshrc` for automatic loading:
```bash
echo "source /Users/laneburgett/lerobot/lerobot_aliases.sh" >> ~/.zshrc
```

### 3. Run Bimanual Teleoperation

**With alias:**
```bash
lerobot-bimanual
```

**Or full command:**
```bash
python lerobot/scripts/control_robot.py \
    --robot.type=so101_bimanual \
    --robot.cameras='{}' \
    --control.type=teleoperate
```

## Hardware Setup

### Port Mappings

- **Leader Left**: `/dev/tty.usbmodem5AAF2702811`
- **Leader Right**: `/dev/tty.usbmodem5AAF2704701`
- **Follower Left**: `/dev/tty.usbmodem5A7A0157861`
- **Follower Right**: `/dev/tty.usbmodem5A7A0157001`

### Calibration

Calibration files are stored in `.cache/calibration/so101_bimanual/`:
- `left_leader.json`
- `right_leader.json`
- `left_follower.json`
- `right_follower.json`

**To recalibrate all arms:**
```bash
rm .cache/calibration/so101_bimanual/*.json
python lerobot/scripts/control_robot.py \
    --robot.type=so101_bimanual \
    --control.type=calibrate
```

## Configuration

### Performance Tuning

The bimanual config is optimized for low latency:
- `max_relative_target: 10` - Allows larger movements per control loop
- Follower `P_Coefficient: 24` - High responsiveness
- Follower `D_Coefficient: 16` - Low damping for fast response

### Motor Direction

The **shoulder_pan** is **mirrored** - when you move the leader left, the follower moves right (and vice versa). This creates a natural mirror-image control for bimanual manipulation.

To mirror other motors, edit the calibration files and change the `drive_mode` value to `1` for that motor.

## Available Commands

After loading aliases with `source lerobot_aliases.sh`:

- `lerobot-bimanual` - Run bimanual teleoperation
- `lerobot-bimanual-calibrate` - Calibrate all 4 arms
- `lerobot-find-port` - Find motor bus ports
- `lerobot-configure-motor` - Configure individual motor IDs
- `cdlerobot` - Navigate to lerobot directory

## Troubleshooting

### Communication Errors

**Issue**: `ConnectionError: Read failed due to communication error`

**Solutions**:
1. Check power cables are connected
2. Check USB cables are properly connected
3. Verify motors are daisy-chained correctly
4. Try unplugging/replugging USB and power
5. Run `lerobot-find-port` to verify port assignments

### Calibration Out of Range

**Issue**: `Wrong motor position range detected`

**Solution**: Recalibrate that arm
```bash
rm .cache/calibration/so101_bimanual/*.json
python lerobot/scripts/control_robot.py \
    --robot.type=so101_bimanual \
    --control.type=calibrate
```

### High Latency

**To reduce latency**:
1. Disable cameras: `--robot.cameras='{}'` (already default)
2. Run without FPS limit (already default)
3. Increase `max_relative_target` in `configs.py` (currently 10)
4. Increase follower `P_Coefficient` in `manipulator.py` (currently 24)

### Motors Too Shaky

**To reduce shakiness**:
1. Lower follower `P_Coefficient` in `manipulator.py` (try 20 or 16)
2. Increase follower `D_Coefficient` (try 24 or 32)

## Technical Details

### Code Changes

Key modifications from base LeRobot:

1. **`lerobot/common/robot_devices/robots/configs.py`**
   - Added `So101BimanualRobotConfig` class
   - Configured 4 arms (2 leaders + 2 followers)
   - Set `max_relative_target: 10`

2. **`lerobot/common/robot_devices/robots/manipulator.py`**
   - Added `set_so101_bimanual_preset()` function
   - Optimized PID parameters for low latency
   - Added `so101_bimanual` to motor type checks

3. **Calibration Files**
   - Converted from old dict format to new array format
   - Set `drive_mode[0] = 1` for mirrored shoulder_pan

### Architecture

The system uses a **master-slave** control scheme:
- Leader arms are read at ~200Hz
- Positions are sent to corresponding follower arms
- Safety limits prevent excessive movements (`max_relative_target`)
- Calibration ensures consistent behavior across robots

## Recording Data

To record bimanual demonstrations:

```bash
python lerobot/scripts/control_robot.py \
    --robot.type=so101_bimanual \
    --control.type=record \
    --control.fps=30 \
    --control.single_task="Your task description" \
    --control.repo_id=your_username/dataset_name \
    --control.num_episodes=50
```

## License

Based on [HuggingFace LeRobot](https://github.com/huggingface/lerobot) - Apache 2.0 License

