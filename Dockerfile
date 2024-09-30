# Base image
FROM ros:humble-ros-base AS base

# Install necessary packages in one layer to minimize image size
RUN apt update && apt install -y \
    python3-genmsg \
    python3-setuptools \
    && rm -rf /var/lib/apt/lists/*

# Clone and build the XRCE-DDS agent in a separate stage to leverage caching
FROM base AS builder
RUN git clone https://github.com/eProsima/Micro-XRCE-DDS-Agent.git /Micro-XRCE-DDS-Agent
WORKDIR /Micro-XRCE-DDS-Agent/build
RUN cmake .. && make -j$(nproc) && make install && ldconfig /usr/local/lib/ \
    && rm -rf /Micro-XRCE-DDS-Agent

# Copy the built dependencies to a new, clean base image to reduce size
FROM base

# Copy installed XRCE-DDS Agent from the builder stage
COPY --from=builder /usr/local/ /usr/local/

# Set up workspace and clone repositories
WORKDIR /ros_ws/src
ADD ./src/ /ros_ws/src/
RUN git clone -b release/1.15 https://github.com/PX4/px4_msgs.git && \
    git clone https://github.com/PX4/px4_ros_com.git && \
    git clone --recursive https://github.com/Auterion/px4-ros2-interface-lib && \
    rm -rf /ros_ws/src/px4-ros2-interface-lib/examples/ && \
    rm -rf /var/lib/apt/lists/*

# Build the ROS workspace
WORKDIR /ros_ws
RUN /bin/bash -c "source /opt/ros/humble/setup.bash && colcon build"

# Set entry point
CMD ["/ros_ws/src/startup.bash"]

