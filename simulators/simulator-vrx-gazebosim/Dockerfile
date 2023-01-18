# syntax=docker/dockerfile:experimental

FROM alpine AS ssh_auth
# install ssh client and git
RUN apk add --no-cache openssh-client git
# download public key for github.com
RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

# clone any private repository
RUN --mount=type=ssh git clone git@github.com:ngxingyu/bbasv_descriptions.git && cd bbasv_descriptions && git checkout c19e50b45b2716f36b0c3002d548b838e41e468e
# RUN --mount=type=ssh git clone git@github.com:BumblebeeAS/simulator.git && cd simulator && git checkout deab89d7575b419c64e5b7f0e17d29c78ce75137
RUN --mount=type=ssh git clone git@github.com:BumblebeeAS/bb_msgs.git && cd bb_msgs && git checkout 869a975ec102de2055818e612758c4bd3c141d49


FROM ghcr.io/ngxingyu/simulator_vrx_gazebosim_base:latest

ADD supervisord.conf /etc/supervisor/supervisord.conf

ENV USER=developer
# add non-root user
RUN useradd -m ${USER} && \
    echo ${USER} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USER} && \
    chmod 0440 /etc/sudoers.d/${USER}
USER ${USER}
WORKDIR /home/${USER}

ENV HOME /home/${USER}
ENV SHELL /bin/bash

# COPY --from=ssh_auth /bbasv_descriptions $HOME/colcon_ws/src/bbasv_descriptions
# COPY --from=ssh_auth /simulator $HOME/colcon_ws/src/simulator # to migrate to ros2
# COPY --from=ssh_auth /bb_msgs $HOME/colcon_ws/src/bb_msgs

# RUN source /opt/ros/humble/setup.bash && \
#     cd ~/colcon_ws && GZ_VERSION=garden colcon build --merge-install

RUN sh -c 'echo "source ~/colcon_ws/install/setup.bash" >> ~/.bashrc'

ADD supervisord.conf /etc/supervisor/supervisord.conf

VOLUME ["${HOME}/colcon_ws/src/"]

CMD [ "sudo", "-E", "/usr/local/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
