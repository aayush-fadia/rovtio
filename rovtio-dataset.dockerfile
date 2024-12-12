# Use NVIDIA OpenGL base image for GPU support
FROM osrf/ros:noetic-desktop-full

# Set environment variables for NVIDIA drivers
# ENV NVIDIA_VISIBLE_DEVICES all
# ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES},display

# Install necessary dependencies
# RUN apt-get update && apt-get install -y --no-install-recommends \
#     ros-noetic-desktop-full \
#     python3-catkin-tools \
#     git \
#     cmake \
#     build-essential \
#     libglew-dev \
#     freeglut3-dev \
#     mesa-utils \
#     libx11-dev \
#     && rm -rf /var/lib/apt/lists/*

# Set up ROS environment
RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
SHELL ["/bin/bash", "-c"]

# Create a workspace for ROVTIO
WORKDIR /root/catkin_ws/


# Install additional dependencies for ROVTIO
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    python3-catkin-tools \
    ros-noetic-cv-bridge \
    libopencv-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /root/src
RUN git clone https://github.com/ethz-asl/kindr.git && \
    cd kindr && \
    mkdir build && \
    cd build && \
    cmake .. && \
    sudo make install

#WORKDIR /root/catkin_ws/src/
# Clone the ROVTIO repository
RUN #git clone --recursive https://github.com/ntnu-arl/rovtio.git rovtio

# Build ROVTIO with OpenGL scene enabled
WORKDIR /root/catkin_ws/
COPY . /root/catkin_ws/src/rovtio/
RUN source /opt/ros/noetic/setup.bash && \
    catkin build rovtio --cmake-args -DCMAKE_BUILD_TYPE=Release -DMAKE_SCENE=OFF -DROVIO_NCAM=2 -DROVIO_NMAXFEATURE=25

# Set up entrypoint to source ROS and workspace setup files
RUN echo "source /root/catkin_ws/devel/setup.bash" >> ~/.bashrc
ENTRYPOINT ["/bin/bash", "-c", "source /root/catkin_ws/devel/setup.bash && exec bash"]
