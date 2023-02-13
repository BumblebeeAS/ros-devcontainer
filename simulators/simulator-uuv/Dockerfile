# syntax=docker/dockerfile:experimental

FROM ghcr.io/ngxingyu/simulator_uuv_base:latest

ADD supervisord.conf /etc/supervisor/supervisord.conf

RUN apt-get update && \
    apt-get install -y ros-noetic-actionlib-tools python3-tf-conversions && \
    apt-get clean

ARG SOURCEFORGE=https://sourceforge.net/projects
ARG VIRTUALGL_VERSION=3.0.2

RUN apt-get update --fix-missing && \
    apt-get install -y libegl1-mesa || true && \
    apt fix-broken install -y || true && \
    apt-get install -y libegl1-mesa || true && apt-get clean &&\
    cd /tmp && \
    curl -fsSL -O ${SOURCEFORGE}/virtualgl/files/${VIRTUALGL_VERSION}/virtualgl_${VIRTUALGL_VERSION}_amd64.deb &&\
    dpkg -i *.deb && \
    rm -rf /tmp/*.deb

USER ${USER}

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

RUN source /opt/ros/noetic/setup.bash && \
    mkdir -p ${HOME}/catkin_ws/src/ && cd ${HOME}/catkin_ws/src/ && catkin_init_workspace

VOLUME ["${HOME}/catkin_ws/src/"]

# CMD [ "sudo", "-E", "/usr/local/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
