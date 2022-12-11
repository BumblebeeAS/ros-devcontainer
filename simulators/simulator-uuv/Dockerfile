FROM ghcr.io/ngxingyu/dockwater:noetic

SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y curl python3-pip python3-rosdep python3-catkin-pkg python3-catkin-tools python3-vcstool git

RUN pip3 install -U --no-cache-dir supervisor supervisor_twiddler

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

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
# github_pat_11ADAYHMA056NRkI71S6Ge_C3SnWmtrPHUsbRdNK9lqYwnbzWgCl3dp6sxkNS1Jcc7KYJZ7OAZ4WeBGK

# Currently imports entire simulator repo, to try separating auv and asv code into separate repos.
RUN cd /root/catkin_ws/src && source /opt/ros/noetic/setup.bash && \
    vcs import < snapshot.repos && \
    cd /root/catkin_ws && \
    rosdep install --from-paths src --ignore-src -r -y --rosdistro noetic && \
    catkin config -a --blacklist bbasv_gazebo_plugins bbasv_gazebo_worlds asv_urdf vrx_urdf && \
    catkin build

ADD ros_entrypoint.sh /ros_entrypoint.sh
RUN chmod 755 /ros_entrypoint.sh

ADD supervisord.conf /etc/supervisor/supervisord.conf

VOLUME ["/root/catkin_ws/src/"]

CMD ["/usr/local/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
