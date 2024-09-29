# px4-ros2-interface
This repository is a template for using the PX4-ROS2 interface in a docker container.

## Instructions
1. Plave your ROS2 package source code in the `src` directory.
2. Build the container:
`docker build --tag px4-ros2-interface .`
3. Start the container using docker compose:
`docker compose up -d`
4. (Optional) To enter execute bash commands in the container, run
`docker exec -it px4-ros2-interface bash`

## Containerized Approach to Offboard Control

### Benefits
- Allows ROS2 code to be run on almost any hardware and OS
- Removes need for user to install ROS2 and other dependecies

### Downsides
- Long build time since the PX4-ROS2 bridge has to be rebuilt each time
- Source code must be changed from outside the container which then has to be rebuilt
- User needs to install docker (still easier than ROS2)
