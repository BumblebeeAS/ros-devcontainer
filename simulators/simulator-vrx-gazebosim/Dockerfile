# syntax=docker/dockerfile:experimental

FROM ghcr.io/bumblebeeas/simulator_vrx_gazebosim_base:latest
# FROM ros-devcontainer:simulator_vrx_gazebosim_base

ADD .devcontainer_ros2/supervisord.conf /etc/supervisor/supervisord.conf

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


# workaround to enable bash completion for apt-get
# see: https://github.com/tianon/docker-brew-ubuntu-core/issues/75
RUN rm /etc/apt/apt.conf.d/docker-clean

# use closest mirror for apt updates
# RUN sed -i -e 's/http:\/\/archive/mirror:\/\/mirrors/' -e 's/http:\/\/security/mirror:\/\/mirrors/' -e 's/\/ubuntu\//\/mirrors.txt/' /etc/apt/sources.list

# Setup locale
ENV LC_ALL=C
RUN apt update && sudo apt install locales \
    && locale-gen en_US en_US.UTF-8 \
    && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 \
    && apt-get clean -qq

RUN apt-get update && \
    apt-get install -y curl apt-transport-https ca-certificates software-properties-common && add-apt-repository universe && \
    apt-get clean

# need to renew the key for some reason
RUN  curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

# OSRF distribution is better for gazebo
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

# nice to have nodejs for web goodies
RUN sh -c 'echo "deb https://deb.nodesource.com/node_16.x `lsb_release -cs` main" > /etc/apt/sources.list.d/nodesource.list' && \
    curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -

# install depending packages
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y bash-completion less wget vim-tiny iputils-ping net-tools openssh-client git openjdk-8-jdk-headless nodejs sudo imagemagick byzanz python3-dev libsecret-1-dev && \
    npm install -g yarn && \
    apt-get clean

# basic python packages
RUN apt-get install -y python-is-python3; \
    curl -kL https://bootstrap.pypa.io/get-pip.py | python && \
    pip install --upgrade pip && \
    pip install --upgrade --ignore-installed --no-cache-dir pyassimp pylint==1.9.4 notebook~=5.7 Pygments matplotlib ipywidgets jupyter_contrib_nbextensions nbimporter supervisor supervisor_twiddler argcomplete

USER ${USER}

ENV USER=developer
# add non-root user
RUN useradd -m ${USER} && \
    echo ${USER} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USER} && \
    chmod 0440 /etc/sudoers.d/${USER}

# install depending packages (install moveit! algorithms on the workspace side, since moveit-commander loads it from the workspace)
RUN apt-get update && apt-get install -y nano ccache \
    python3-pydantic \
    ros-$ROS_DISTRO-joint-state-publisher \
    ros-$ROS_DISTRO-robot-localization \
    ros-$ROS_DISTRO-plotjuggler-ros \
    ros-$ROS_DISTRO-ros2bag \
    ros-$ROS_DISTRO-rosbag2-storage-default-plugins \
    ros-$ROS_DISTRO-rqt-tf-tree \
    ros-$ROS_DISTRO-rmw-fastrtps-cpp \
    ros-$ROS_DISTRO-rmw-cyclonedds-cpp \
    ros-$ROS_DISTRO-slam-toolbox \
    ros-$ROS_DISTRO-turtlebot3 \
    ros-$ROS_DISTRO-turtlebot3-msgs \
    ros-$ROS_DISTRO-twist-mux \
    ros-$ROS_DISTRO-usb-cam && \
    apt-get clean

# eigen quadprog for controls
RUN curl -1sLf \
  'https://dl.cloudsmith.io/public/mc-rtc/stable/setup.deb.sh' \
  | sudo -E bash && apt-get update && apt-get -y upgrade && apt-get install -y libeigen-quadprog-dev \
    && apt-get clean

USER ${USER}
WORKDIR /home/${USER}

ENV HOME /home/${USER}
ENV SHELL /bin/bash
ENV ROS_VERSION 2


# init rosdep
RUN rosdep update

RUN sudo chown -R ${USER}:${USER} /home/${USER}

RUN sh -c 'echo "source ~/colcon_ws/install/setup.bash" >> ~/.bashrc'
VOLUME ["${HOME}/colcon_ws/src/"]