FROM ros:melodic

# These values will be overrided by `docker run --env <key>=<value>` command
ENV ROS_IP 127.0.0.1
ENV ROS_MASTER_URI http://127.0.0.1:11311

# Install some basic dependencies
RUN apt-get update && apt-get -y upgrade && apt-get -y install \
  curl ssh python-pip python3-pip \
  && rm -rf /var/lib/apt/lists/*

# Set root password
RUN echo 'root:root' | chpasswd

# Permit SSH root login
RUN sed -i 's/#*PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

ARG FR_VERBOSE="false"
ARG FR_VERSION="latest"

# Override these variables when running the image
ENV FR_ACCOUNT="INSTALL_ONLY"
ENV FR_DEVICE="GENERIC_DEVICE"
ENV FR_TOKEN="INSTALL_ONLY_DEVICE_TOKEN"
ENV FR_SECRET=""

ENV FR_INSTALL_ELEMENTS="warn_no_fail,no_credentials,service_none,webrtc"
ENV FR_URL="https://api.freedomrobotics.ai/accounts/${FR_ACCOUNT}/devices/${FR_DEVICE}/installscript?\
mc_token=${FR_TOKEN}\
&code_version=${FR_VERSION}\
&install_elements=${FR_INSTALL_ELEMENTS}\
&auto_install_deps=true\
&ppa_is_allowed=true\
&verbose=${FR_VERBOSE}"

# Install Freedom agent
RUN curl -s "${FR_URL}" | python \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /root/.cache/pip/* 

# Install catkin-tools
RUN apt-get update && apt-get install -y python-catkin-tools \
  && rm -rf /var/lib/apt/lists/*

# Install Freedom scripts
RUN mkdir /freedom
COPY ./freedom_register.py /freedom/
COPY ./freedom_keep_alive.py /freedom/
COPY ./entrypoint.sh /freedom/

ENTRYPOINT ["/freedom/entrypoint.sh"]
