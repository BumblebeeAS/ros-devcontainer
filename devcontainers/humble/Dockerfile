# ARG BASE_IMAGE=ghcr.io/ngxingyu/dockwater:humble
ARG BASE_IMAGE=ghcr.io/ngxingyu/ros-devcontainer:humble-base

FROM maven:3.8.6-openjdk-18 AS xsdcache

# install schema-fetcher
RUN microdnf install git && \
    git clone --depth=1 https://github.com/mfalaize/schema-fetcher.git && \
    cd schema-fetcher && \
    mvn install

# fetch XSD file for package.xml
RUN mkdir -p /opt/xsd/package.xml && \
    java -jar schema-fetcher/target/schema-fetcher-1.0.0-SNAPSHOT.jar /opt/xsd/package.xml http://download.ros.org/schema/package_format3.xsd

# fetch XSD file for roslaunch
RUN mkdir -p /opt/xsd/roslaunch && \
    java -jar schema-fetcher/target/schema-fetcher-1.0.0-SNAPSHOT.jar /opt/xsd/roslaunch https://gist.githubusercontent.com/nalt/dfa2abc9d2e3ae4feb82ca5608090387/raw/roslaunch.xsd

# fetch XSD files for SDF
RUN mkdir -p /opt/xsd/sdf && \
    java -jar schema-fetcher/target/schema-fetcher-1.0.0-SNAPSHOT.jar /opt/xsd/sdf http://sdformat.org/schemas/root.xsd && \
    sed -i 's|http://sdformat.org/schemas/||g' /opt/xsd/sdf/*

# fetch XSD file for URDF
RUN mkdir -p /opt/xsd/urdf && \
    java -jar schema-fetcher/target/schema-fetcher-1.0.0-SNAPSHOT.jar /opt/xsd/urdf https://raw.githubusercontent.com/devrt/urdfdom/xsd-with-xacro/xsd/urdf.xsd

FROM $BASE_IMAGE

ENV USER=developer

SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND noninteractive

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

# add non-root user
RUN useradd -m ${USER} && \
    echo ${USER} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USER} && \
    chmod 0440 /etc/sudoers.d/${USER}

# install depending packages (install moveit! algorithms on the workspace side, since moveit-commander loads it from the workspace)
RUN apt-get update && apt-get install -y nano \
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

# install bio_ik
# RUN source /opt/ros/$ROS_DISTRO/setup.bash && \
#     mkdir -p /bio_ik_ws/src && \
#     cd /bio_ik_ws/src && \
#     catkin_init_workspace && \
#     git clone --depth=1 https://github.com/TAMS-Group/bio_ik.git && \
#     cd .. && \
#     catkin_make install -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/opt/ros/$ROS_DISTRO -DCATKIN_ENABLE_TESTING=0 && \
#     cd / && rm -r /bio_ik_ws

# configure services
RUN mkdir -p /etc/supervisor/conf.d
COPY .devcontainer_ros2/supervisord.conf /etc/supervisor/supervisord.conf

COPY .devcontainer_ros2/entrypoint.sh /entrypoint.sh

COPY .devcontainer_ros2/sim.py /usr/bin/sim

COPY --from=xsdcache /opt/xsd /opt/xsd

USER $USER
WORKDIR /home/${USER}

ENV HOME /home/${USER}
ENV SHELL /bin/bash

# jre is required to use XML editor extension
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

# colorize less
RUN echo "export LESS='-R'" >> ~/.bash_profile && \
    echo "export LESSOPEN='|pygmentize -g %s'" >> ~/.bash_profile

# enable bash completion
RUN git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it && \
    ~/.bash_it/install.sh --silent && \
    rm ~/.bashrc.bak && \
    echo "source /usr/share/bash-completion/bash_completion" >> ~/.bashrc && \
    bash -i -c "bash-it enable completion git"

RUN echo 'eval "$(register-python-argcomplete sim)"' >> ~/.bashrc

RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
    ~/.fzf/install --all

RUN git clone --depth 1 https://github.com/b4b4r07/enhancd.git ~/.enhancd && \
    echo "source ~/.enhancd/init.sh" >> ~/.bashrc

# init rosdep
RUN rosdep update

# global vscode config
ADD .vscode_ros2 /home/${USER}/.vscode
# ADD .vscode /home/${USER}/.theia
ADD .devcontainer_ros2/compile_flags.txt /home/${USER}/compile_flags.txt
ADD .devcontainer_ros2/templates /home/${USER}/templates
RUN sudo chown -R ${USER}:${USER} /home/${USER}

# ENV THEIA_DEFAULT_PLUGINS local-dir:/home/${USER}/plugins

# enter ROS world
RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> ~/.bashrc

EXPOSE 3000 8888

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "sudo", "-E", "/usr/local/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
