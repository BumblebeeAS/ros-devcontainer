# syntax=docker/dockerfile:experimental

FROM ghcr.io/ngxingyu/simulator_vrx_gazebosim_base:latest

ADD supervisord.conf /etc/supervisor/supervisord.conf

ENV USER=developer
# add non-root user
RUN useradd -m ${USER} && \
    echo ${USER} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USER} && \
    chmod 0440 /etc/sudoers.d/${USER}
USER ${USER}
WORKDIR /home/${USER}

ENV HOME /home/${USER}
ENV SHELL /bin/bash

RUN sh -c 'echo "source ~/colcon_ws/install/setup.bash" >> ~/.bashrc'

ADD supervisord.conf /etc/supervisor/supervisord.conf

VOLUME ["${HOME}/colcon_ws/src/"]