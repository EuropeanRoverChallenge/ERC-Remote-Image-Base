# ERC Remote Base Docker Image
This Docker image is intented to be used by the teams as a base image for providing custom software in the ERC Remote competition.
The image can be extended using `FROM` command in another Dockerfile:
```Dockerfile
FROM ghcr.io/europeanroverchallenge/erc-remote-image-base:latest
```
For an example and more information, check the [ERC-Remote-Navigation-Example](https://github.com/EuropeanRoverChallenge/ERC-Remote-Navigation-Example) repository.

This image is our most tested setup for connecting real hardware available on the ERC Remote competition with the Freedom Robotics platform. We advise against using any other setups (for example, using different ROS distribution) as we can't guarantee they will work during the competition.

## Features
The Dockerfile extends the [ros:melodic](https://hub.docker.com/_/ros) image, which is a Ubuntu 18.04 distribution with ROS Melodic installed. Apart from that, it:
 - Installs the Freedom agent - The agent will connect to the device on the Freedom Robotics platform to let the team control the robot.
 - Sets the password for the root account - This is needed for logging via Freedom Robotics SSH tunnel.
 - Adds 2 python scripts:
   - `freedom_register.py` - Creates the credentials file for connecting to the Freedom Robotics platform (based on the environment variables) and registers the agent as a init.d service.
   - `freedom_keep_alive.py` - Starts the Freedom agent service and ensures it stays alive by restarting it whenever it exits.
 - Adds an entrypoint that:
   - Exports the `ROS_IP` and `ROS_MASTER_URI` variables, that were passed to the started container, to a system-wide variable configuration (`/etc/environment` file) - This ensures that a correct ROS network configuration is exported when starting any new shell session (for example, when connecting via SSH).
   - Starts the Freedom agent using the aforementioned scripts.
   - Runs the command passed to the container.

## Acknowledgements
The `freedom_register.py` and `freedom_keep_alive.py` scripts come from [this gist](https://gist.github.com/hcl337/12113fd6099d061e6283c2ed80a62610) which is a part of [this guide](https://docs.freedomrobotics.ai/docs/deploying-with-docker). 