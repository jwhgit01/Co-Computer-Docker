# Base image
FROM ros:humble-ros-base

# Install some Python dependencies
RUN apt update && apt install python3-genmsg python3-setuptools -y 

# Set up the XRCE-DDS agent
RUN git clone https://github.com/eProsima/Micro-XRCE-DDS-Agent.git
WORKDIR /Micro-XRCE-DDS-Agent/build
RUN cmake .. && make && make install && ldconfig /usr/local/lib/

# Add source code into workspace
ADD ./src /colcon_ws/src

# Clone PX4 dependecies into the workspace
WORKDIR /colcon_ws/src
RUN git clone https://github.com/PX4/px4_msgs.git
RUN git clone https://github.com/PX4/px4_ros_com.git
RUN git clone --recursive https://github.com/Auterion/px4-ros2-interface-lib

# Build the ROS workspace
WORKDIR /colcon_ws
RUN /bin/bash -c "source /opt/ros/humble/setup.bash && colcon build"

# Source the ROS installation and the interface build
RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc
RUN echo "source /colcon_ws/install/setup.bash" >> /root/.bashrc

# Set entry point
CMD ["/bin/bash"]
