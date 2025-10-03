# leader-left arm is /dev/tty.usbmodem5AAF2702811
# leader-right arm is /dev/tty.usbmodem5AAF2704701 
# follower-left arm is /dev/tty.usbmodem5A7A0157861  
# follower-right arm is /dev/tty.usbmodem5A7A0157001

# Command to do teleop for left arms
lerobot-teleoperate \
    --robot.type=so101_follower \
    --robot.port=/dev/tty.usbmodem5A7A0157861 \
    --teleop.type=so101_leader \
    --teleop.port=/dev/tty.usbmodem5AAF2702811

# Command to do teleop for left leader and right follower
lerobot-teleoperate \
    --robot.type=so101_follower \
    --robot.port=/dev/tty.usbmodem5A7A0157001 \
    --robot.id=follower_right \
    --teleop.type=so101_leader \
    --teleop.port=/dev/tty.usbmodem5AAF2702811 \
    --teleop.id=leader_left

lerobot-calibrate \
    --teleop.type=so101_leader \
    --teleop.port=/dev/tty.usbmodem5AAF2704701 

lerobot-setup-motors \
    --teleop.type=so101_leader \
    --teleop.port=/dev/tty.usbmodem5AAF2704701 