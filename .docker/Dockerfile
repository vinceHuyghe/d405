ARG ROSDISTRO=noetic

FROM ros:$ROSDISTRO-robot

ARG ROSDISTRO

# Set environment variables
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

ENV TERM xterm-256color

# Tools
RUN apt update && apt install -y \
    ssh \
    git \
    python3-pip \
    python3-flake8 \
    build-essential \
    cmake \
    wget \
    zsh 


# ROS
RUN apt update && apt install -y \
    pkg-config \
    python3-catkin-tools \
    python3-rosdep \
    python3-rosinstall-generator \
    python3-vcstool \
    ros-$ROSDISTRO-rqt \
    ros-$ROSDISTRO-rqt-action \
    ros-$ROSDISTRO-rqt-console \
    ros-$ROSDISTRO-rqt-service-caller \
    ros-$ROSDISTRO-rqt-graph \
    ros-$ROSDISTRO-rqt-topic \
    ros-$ROSDISTRO-rqt-top \
    ros-$ROSDISTRO-rviz \
    # Realsense
    ros-$ROS_DISTRO-rqt-image-view \
    software-properties-common \
    ros-$ROS_DISTRO-ddynamic-reconfigure \
    ros-$ROS_DISTRO-rgbd-launch 



RUN apt-key adv \
        --keyserver keyserver.ubuntu.com \
        --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE || \
        apt-key adv \
        --keyserver hkp://keyserver.ubuntu.com:80 \
        --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE \
    && add-apt-repository "deb https://librealsense.intel.com/Debian/apt-repo $(lsb_release -cs) main" -u \
    && apt-get install -y --install-recommends \
        librealsense2-dkms librealsense2-utils \
        librealsense2-dev librealsense2-dbg

# Reduce size by removing apt cache
RUN ["/bin/bash", "-c", "rm -rf /var/lib/apt/lists/*"]

# Add nice permision to container
RUN echo "* - nice -15" >> /etc/security/limits.conf

# Create workspace
RUN mkdir -p dev_ws/src
WORKDIR /dev_ws/src

# Clone STOMP and rqt_joint_trajectory pkgs
RUN ["/bin/bash", "-c", "git clone https://github.com/rjwb1/realsense-ros.git"]

# Build workspace
WORKDIR /dev_ws

RUN ["/bin/bash", "-c", "source /opt/ros/$ROSDISTRO/setup.bash &&\
    catkin config --cmake-args -DCMAKE_BUILD_TYPE=Release &&\
    catkin build \
    "]

# Set shell to zsh
SHELL ["zsh", "chsh -s ~/.zshrc" ]

COPY .docker/setup.zsh /dev_ws/setup.zsh
RUN ["/bin/bash", "-c", "chmod 777 /dev_ws/setup.zsh"]

COPY .docker/entrypoint_zsh.sh /dev_ws/entrypoint_zsh.sh
RUN ["/bin/bash", "-c", "chmod 777 /dev_ws/entrypoint_zsh.sh"]

ENTRYPOINT ["zsh", "/dev_ws/entrypoint_zsh.sh" ]

# ZSH
CMD ["zsh"]