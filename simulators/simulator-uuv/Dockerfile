# syntax=docker/dockerfile:experimental

FROM alpine AS ssh_auth
# install ssh client and git
RUN apk add --no-cache openssh-client git
# download public key for github.com
RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

# clone any private repository
RUN --mount=type=ssh git clone git@github.com:ngxingyu/bbauv_descriptions.git && cd bbauv_descriptions && git checkout a9827c0cccad5b32d0590698dca6bbfa53c77df9
RUN --mount=type=ssh git clone git@github.com:BumblebeeAS/simulator.git && cd simulator && git checkout deab89d7575b419c64e5b7f0e17d29c78ce75137
RUN --mount=type=ssh git clone git@github.com:BumblebeeAS/bb_msgs.git && cd bb_msgs && git checkout 869a975ec102de2055818e612758c4bd3c141d49

FROM ghcr.io/ngxingyu/simulator_uuv_base:latest

COPY --from=ssh_auth /bbauv_descriptions /root/catkin_ws/src/bbauv_descriptions
COPY --from=ssh_auth /simulator /root/catkin_ws/src/simulator
COPY --from=ssh_auth /bb_msgs /root/catkin_ws/src/bb_msgs

RUN source /opt/ros/noetic/setup.bash && source /root/uuv_ws/devel/setup.bash && \
    cd /root/catkin_ws && rosdep install --from-paths src --ignore-src -r -y --rosdistro noetic && \
    catkin config -a --blacklist bbasv_gazebo_plugins bbasv_gazebo_worlds bbuav_gazebo_plugins asv_urdf vrx_urdf && \
    catkin build

ADD ros_entrypoint.sh /ros_entrypoint.sh
RUN chmod 755 /ros_entrypoint.sh

RUN sh -c 'echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc'

ADD supervisord.conf /etc/supervisor/supervisord.conf

VOLUME ["/root/catkin_ws/src/", "/home/developer/catkin_ws/src/"]

CMD ["/usr/local/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
