FROM ros:noetic-ros-core

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential wget \
    ros-${ROS_DISTRO}-cv-bridge ros-${ROS_DISTRO}-tf ros-${ROS_DISTRO}-message-filters ros-${ROS_DISTRO}-image-transport* \
    ros-${ROS_DISTRO}-eigen-conversions ros-${ROS_DISTRO}-pcl-ros ros-${ROS_DISTRO}-rviz \
    libcgal-dev pcl-tools \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /catkin_ws/src

COPY r3live r3live
COPY livox_ros_driver livox_ros_driver


WORKDIR /catkin_ws

RUN . /opt/ros/${ROS_DISTRO}/setup.sh && catkin_make --cmake-args -DCMAKE_BUILD_TYPE=Release

WORKDIR /

COPY resources/ros_entrypoint.sh .


# Download test bag
ARG GDRIVE_BAGFILE_ID=1jeER_vhlcLSmNdQkMvI2uwuPdiwZSyJL
ARG GDRIVE_BAGFILE_NAME=hku_campus_seq_00.bag
ENV GDRIVE_BAGFILE_NAME=${GDRIVE_BAGFILE_NAME}

RUN wget -q --load-cookies /tmp/cookies.txt \ 
    "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=$GDRIVE_BAGFILE_ID' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=$GDRIVE_BAGFILE_ID" -O $GDRIVE_BAGFILE_NAME && rm -rf /tmp/cookies.txt

WORKDIR /catkin_ws

RUN echo 'alias build="catkin_make --cmake-args -DCMAKE_BUILD_TYPE=Release"' >> ~/.bashrc
RUN echo 'alias run="roslaunch r3live docker_r3live_bag.launch"' >> ~/.bashrc
