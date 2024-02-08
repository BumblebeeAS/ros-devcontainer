ARG BASE_IMAGE=ghcr.io/bumblebeeas/ros-devcontainer:noetic-base
# ARG BASE_IMAGE=ros-devcontainer:noetic-base

FROM maven:3.8.6-openjdk-18 AS xsdcache

# install schema-fetcher
RUN microdnf install git && \
    git clone --depth=1 https://github.com/mfalaize/schema-fetcher.git && \
    cd schema-fetcher && \
    mvn install

# fetch XSD file for package.xml
RUN mkdir -p /opt/xsd/package.xml && \
    java -jar schema-fetcher/target/schema-fetcher-1.0.0-SNAPSHOT.jar /opt/xsd/package.xml http://download.ros.org/schema/package_format2.xsd

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
RUN sed -i -e 's/http:\/\/archive/mirror:\/\/mirrors/' -e 's/http:\/\/security/mirror:\/\/mirrors/' -e 's/\/ubuntu\//\/mirrors.txt/' /etc/apt/sources.list

# Setup locale
ENV LC_ALL=C
RUN apt update && sudo apt install locales \
  && locale-gen en_US en_US.UTF-8 \
  && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 \
  && apt-get clean -qq

RUN apt-get update && \
    apt-get install -y curl apt-transport-https ca-certificates && \
    apt-get clean

# need to renew the key for some reason
# RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc

# OSRF distribution is better for gazebo
RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list' && \
    curl -L http://packages.osrfoundation.org/gazebo.key | apt-key add -

# nice to have nodejs for web goodies
RUN sh -c 'echo "deb https://deb.nodesource.com/node_14.x `lsb_release -cs` main" > /etc/apt/sources.list.d/nodesource.list' && \
    curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -

# install depending packages
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    bash-completion \
    byzanz \
    git \
    imagemagick \
    iputils-ping \
    less \
    libsecret-1-dev \
    net-tools \
    nodejs \
    openssh-client \
    openjdk-8-jdk-headless \
    python3-dev \
    sudo \
    ros-noetic-actionlib-tools \
    vim-tiny \
    xorg-dev\
    wget \
    && npm install -g yarn \
    && apt-get clean

# basic python packages
RUN apt-get install -y python-is-python3; \
    curl -kL https://bootstrap.pypa.io/get-pip.py | python && \
    pip3 install --upgrade pip && \
    pip3 install --upgrade --ignore-installed --no-cache-dir pyassimp pylint==1.9.4 notebook~=5.7 Pygments matplotlib nbimporter supervisor supervisor_twiddler argcomplete

# add non-root user
RUN useradd -m ${USER} && \
    echo ${USER} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USER} && \
    chmod 0440 /etc/sudoers.d/${USER}

# eigen quadprog for controls
RUN curl -1sLf \
  'https://dl.cloudsmith.io/public/mc-rtc/stable/setup.deb.sh' \
  | sudo -E bash && apt-get update && apt-get -y upgrade && apt-get install -y libeigen-quadprog-dev \
    && apt-get clean

RUN pip3 install --upgrade --ignore-installed --no-cache-dir torch torchvision --extra-index-url https://download.pytorch.org/whl/cpu

# deps for mission-planner
RUN pip3 install transforms3d ultralytics pandas numpy==1.21 opencv-python motrackers gtsam shapely scikit-learn
RUN apt-get update && apt-get install -y qtbase5-dev libqt5svg5-dev libzmq3-dev libdw-dev ros-noetic-ros-babel-fish \
ros-$ROS_DISTRO-foxglove-bridge \
ros-$ROS_DISTRO-map-server \
ros-$ROS_DISTRO-rosmon \
ros-$ROS_DISTRO-pybind11-catkin ros-$ROS_DISTRO-ros-numpy\
&& apt-get clean


# configure services
RUN mkdir -p /etc/supervisor/conf.d
COPY .devcontainer_ros1/supervisord.conf /etc/supervisor/supervisord.conf

COPY .devcontainer_ros1/entrypoint.sh /entrypoint.sh

COPY .devcontainer_ros1/sim.py /usr/bin/sim

COPY --from=xsdcache /opt/xsd /opt/xsd

USER ${USER}
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
ADD .vscode_ros1 /home/${USER}/.vscode
# ADD .vscode /home/${USER}/.theia
ADD .devcontainer_ros1/compile_flags.txt /home/${USER}/compile_flags.txt
ADD .devcontainer_ros1/templates /home/${USER}/templates
RUN sudo chown -R ${USER}:${USER} /home/${USER}

RUN wget https://s3.us-west-1.amazonaws.com/download.behaviortree.dev/groot2_linux_installer/Groot2-v1.5.2-x86_64.AppImage -O /home/${USER}/Groot2-v1.5.2-x86_64.AppImage && chmod +x /home/${USER}/Groot2-v1.5.2-x86_64.AppImage && /home/${USER}/Groot2-v1.5.2-x86_64.AppImage --appimage-extract && mv /home/${USER}/squashfs-root /home/${USER}/Groot2

# enter ROS world
RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash && source ~/workspace/devel/setup.bash" >> ~/.bashrc

EXPOSE 3000 8888

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "sudo", "-E", "/usr/local/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
