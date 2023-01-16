# syntax=docker/dockerfile:experimental

FROM ghcr.io/ngxingyu/ros-devcontainer:noetic-base as noetic

SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y curl python3-pip python3-rosdep python3-catkin-pkg python3-catkin-tools python3-vcstool git && \
    apt clean
RUN pip3 install -U --no-cache-dir supervisor supervisor_twiddler

# OSRF distribution is better for gazebo
RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list' && \
    curl -L http://packages.osrfoundation.org/gazebo.key | apt-key add -

RUN mkdir -p /root/catkin_ws/src && cd /root/catkin_ws/src

ADD snapshot.repos /root/catkin_ws/src/

RUN apt-get update && apt-get install -y ros-noetic-rviz && \
    apt-get clean

# RUN git clone --depth 1 https://github.com/osrf/uctf.git /tmp/uctf && \
#     cp -r /tmp/uctf/models/iris_with_standoffs_demo /usr/share/gazebo-11/models/ && \
#     rm -r /tmp/uctf

FROM alpine AS ssh_auth
# install ssh client and git
RUN apk add --no-cache openssh-client git
# download public key for github.com
RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

# clone any private repository
RUN --mount=type=ssh git clone git@github.com:ngxingyu/bbauv_descriptions.git && cd bbauv_descriptions && git checkout a9827c0cccad5b32d0590698dca6bbfa53c77df9
RUN --mount=type=ssh git clone git@github.com:BumblebeeAS/simulator.git && cd simulator && git checkout deab89d7575b419c64e5b7f0e17d29c78ce75137
RUN --mount=type=ssh git clone git@github.com:BumblebeeAS/bb_msgs.git && cd bb_msgs && git checkout 869a975ec102de2055818e612758c4bd3c141d49

FROM noetic as noetic2


COPY --from=ssh_auth /bbauv_descriptions /root/catkin_ws/src/bbauv_descriptions
COPY --from=ssh_auth /simulator /root/catkin_ws/src/simulator
COPY --from=ssh_auth /bb_msgs /root/catkin_ws/src/bb_msgs

# Currently imports entire simulator repo, to try separating auv and asv code into separate repos.
RUN cd /root/catkin_ws/src && source /opt/ros/noetic/setup.bash && \
    vcs import < snapshot.repos && \
    cd /root/catkin_ws && \
    rosdep install --from-paths src --ignore-src -r -y --rosdistro noetic && \
    catkin config -a --blacklist bbasv_gazebo_plugins bbasv_gazebo_worlds bbuav_gazebo_plugins asv_urdf vrx_urdf && \
    catkin build

# RUN apt-get update && apt-get install -y mesa-utils bash libxtst6:amd64 libgl1-mesa-glx:amd64 libegl1-mesa && curl -L https://sourceforge.net/projects/virtualgl/files/3.0.2/virtualgl_3.0.2_amd64.deb/download --output virtualgl_3.0.2_amd64.deb && \
#     dpkg -i virtualgl_3.0.2_amd64.deb && apt --fix-broken install && dpkg -i virtualgl_3.0.2_amd64.deb
# RUN printf "1\nn\nn\nn\nx\n" | /opt/VirtualGL/bin/vglserver_config

ADD ros_entrypoint.sh /ros_entrypoint.sh
RUN chmod 755 /ros_entrypoint.sh

RUN sh -c 'echo "source /opt/ros/noetic/setup.bash && source ~/catkin_ws/devel/setup.bash" > ~/.bashrc'

ADD supervisord.conf /etc/supervisor/supervisord.conf

VOLUME ["/root/catkin_ws/src/"]

CMD ["/usr/local/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
