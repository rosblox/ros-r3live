#!/bin/bash

xhost +

docker run -it --rm --privileged --net=host \
--volume $(pwd)/r3live:/catkin_ws/src/r3live \
--volume $(pwd)/livox_ros_driver:/catkin_ws/src/livox_ros_driver \
-e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
ghcr.io/rosblox/ros-r3live:noetic
