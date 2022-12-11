FROM ghcr.io/ngxingyu/dockwater:melodic

SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y curl python-pip && \
    pip install -U --no-cache-dir supervisor supervisor_twiddler && \
    apt-get clean

RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list' && \
    curl -L http://packages.osrfoundation.org/gazebo.key | apt-key add -

RUN apt-get update && \
    apt-get install -y ros-melodic-vrx-gazebo && \
    apt-get clean

ADD supervisord.conf /etc/supervisor/supervisord.conf

VOLUME ["/opt/ros/melodic/share/wamv_description", "/opt/ros/melodic/share/wamv_gazebo"]

CMD ["/usr/local/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
