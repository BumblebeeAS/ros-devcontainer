# syntax=docker/dockerfile:experimental

FROM ghcr.io/ngxingyu/simulator_uuv_base:latest

ADD supervisord.conf /etc/supervisor/supervisord.conf

RUN apt-get install -y ros-noetic-actionlib-tools python3-tf-conversions

ENV USER=developer
# add non-root user
RUN useradd -m ${USER} && \
    echo ${USER} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USER} && \
    chmod 0440 /etc/sudoers.d/${USER}
USER ${USER}
WORKDIR /home/${USER}

ENV HOME /home/${USER}
ENV SHELL /bin/bash

# init rosdep
RUN rosdep update

RUN sudo chown -R ${USER}:${USER} /home/${USER}

RUN sh -c 'echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc'

VOLUME ["${HOME}/catkin_ws/src/"]