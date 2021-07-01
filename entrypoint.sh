#!/bin/bash -m

echo "ROS_IP=${ROS_IP}" >> /etc/environment
echo "ROS_MASTER_URI=${ROS_MASTER_URI}" >> /etc/environment

# Read the credentials for the device from environment variables
# FR_DEVICE, FR_TOKEN, FR_SECRET then register Freedom Robotics
# as a system service with a keep-alive if it exits.
python /freedom/freedom_register.py
python /freedom/freedom_keep_alive.py &

# Run the command
$@

fg
