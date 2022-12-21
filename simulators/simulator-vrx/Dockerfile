# syntax=docker/dockerfile:experimental
FROM alpine AS ssh_auth
# install ssh client and git
RUN apk add --no-cache openssh-client git
# download public key for github.com
RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

# clone any private repository
RUN --mount=type=ssh git clone git@github.com:ngxingyu/bbasv_descriptions.git && cd bbasv_descriptions && git checkout c19e50b45b2716f36b0c3002d548b838e41e468e
RUN --mount=type=ssh git clone git@github.com:BumblebeeAS/simulator.git && cd simulator && git checkout fc1cf1d5653933b70fc280bcf4ef700d63d47665
RUN --mount=type=ssh git clone git@github.com:BumblebeeAS/bb_msgs.git && cd bb_msgs && git checkout 869a975ec102de2055818e612758c4bd3c141d49

FROM ghcr.io/ngxingyu/dockwater:noetic

SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y curl python3-pip python3-rosdep python3-catkin-pkg python3-catkin-tools git && \
    apt-get clean
RUN pip3 install -U --no-cache-dir supervisor supervisor_twiddler

RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list' && \
    curl -L http://packages.osrfoundation.org/gazebo.key | apt-key add -


# RUN source /opt/ros/noetic/setup.bash && \
#     mkdir -p ~/catkin_ws/src && cd ~/catkin_ws/src && \
#     catkin_init_workspace && \
#     git clone --depth 1 https://github.com/avidbots/flatland.git && \
#     git clone --depth 1 https://github.com/avidbots/turtlebot_flatland.git && \
#     git clone --depth 1 -b melodic https://github.com/turtlebot/turtlebot.git && \
#     git clone --depth 1 https://github.com/turtlebot/turtlebot_apps.git && \
#     rm -r turtlebot_apps/turtlebot_actions && \
#     rm -r turtlebot_apps/turtlebot_follower && \
#     cd .. && \
#     rosdep update && apt-get update && \
#     apt-get install -y supervisor && \
#     rosdep install --from-paths src --ignore-src -r -y && \
#     catkin_make -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/opt/ros/noetic install && \
#     cp -r src/turtlebot_flatland /opt/ros/noetic/share/ && \
#     apt-get clean && rm -r ~/catkin_ws

COPY --from=ssh_auth /bbasv_descriptions /root/catkin_ws/src/bbasv_descriptions
COPY --from=ssh_auth /simulator /root/catkin_ws/src/simulator
COPY --from=ssh_auth /bb_msgs /root/catkin_ws/src/bb_msgs

RUN apt-get update && apt-get install -y libgoogle-glog-dev ros-noetic-octomap-ros && \
    source /opt/ros/noetic/setup.bash && mkdir -p ~/vrx_ws/src && cd ~/vrx_ws/src &&  git clone https://github.com/ethz-asl/mav_comm.git && \
    git clone https://github.com/ethz-asl/rotors_simulator.git && \
    cd ~/vrx_ws && catkin build rotors_simulator

RUN source /opt/ros/noetic/setup.bash && \
    mkdir -p ~/vrx_ws/src && cd ~/vrx_ws/src && git clone --depth 1 https://github.com/ngxingyu/vrx.git -b robotx22 && \
    cd ~/vrx_ws && \
    rosdep install -i --from-path src --ignore-src -r -y --rosdistro noetic && \
    catkin build && source ~/vrx_ws/devel/setup.bash && \
    cd ~/catkin_ws && \
    catkin config -a --blacklist bbuav_gazebo_plugins && \
    catkin build bbasv_gazebo_plugins vrx_urdf asv_urdf bb_sim_bridge

# RUN apt-get update && apt-get install -y mesa-utils bash libxtst6:amd64 libgl1-mesa-glx:amd64 libegl1-mesa && curl -L https://sourceforge.net/projects/virtualgl/files/3.0.2/virtualgl_3.0.2_amd64.deb/download --output virtualgl_3.0.2_amd64.deb && \ 
#     dpkg -i virtualgl_3.0.2_amd64.deb && apt --fix-broken install && dpkg -i virtualgl_3.0.2_amd64.deb && rm -rf /var/lib/apt/lists/*
# RUN printf "1\nn\nn\nn\nx\n" | /opt/VirtualGL/bin/vglserver_config

# COPY marker /dev/null
ADD ros_entrypoint.sh /ros_entrypoint.sh
RUN chmod 755 /ros_entrypoint.sh

ADD supervisord.conf /etc/supervisor/supervisord.conf

VOLUME ["/root/vrx_ws/src/", "/home/developer/vrx_ws/src/"]

CMD ["/usr/local/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
