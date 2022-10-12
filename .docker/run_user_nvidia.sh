#!/usr/bin/env bash

# privileged flag required for ubuntu 20.04

echo -e "Starting up the user d405 container. \nThis container will access to the users home directory and log in as the user with their password and x sever access.\nYou will not own the workspace though, use sudo chown -R $USER /dev_ws"

docker run -it --privileged \
    --user=$(id -u $USER):$(id -g $USER) \
    --group-add sudo \
    --env="DISPLAY" \
    --env=QT_X11_NO_MITSHM=1 \
    --workdir="/dev_ws" \
    --volume="/home/$USER:/home/$USER" \
    --volume="/etc/group:/etc/group:ro" \
    --volume="/etc/passwd:/etc/passwd:ro" \
    --volume="/etc/shadow:/etc/shadow:ro" \
    --volume="/etc/sudoers.d:/etc/sudoers.d:ro" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --net=host \
    --cap-add=sys_nice \
    --gpus 'all,"capabilities=compute,display,graphics,utility"' \
    d405:latest