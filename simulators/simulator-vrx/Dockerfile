# syntax=docker/dockerfile:experimental

FROM ghcr.io/ngxingyu/simulator_vrx_base:latest

ADD supervisord.conf /etc/supervisor/supervisord.conf

ARG SOURCEFORGE=https://sourceforge.net/projects
ARG VIRTUALGL_VERSION=3.0.2

RUN apt-get update --fix-missing && \
    apt-get install -y libegl1-mesa || true && \
    apt-get install -y libxtst6 || true && \
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

RUN sh -c 'echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc'

VOLUME ["${HOME}/catkin_ws/src/"]

# CMD [ "sudo", "-E", "/usr/local/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
