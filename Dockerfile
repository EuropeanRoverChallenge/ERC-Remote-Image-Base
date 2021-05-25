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

# Install Freedom agent
ENV FR_INSTALL_ELEMENTS="warn_no_fail,no_credentials,service_none,webrtc"
ENV FR_URL="https://api.freedomrobotics.ai/accounts/INSTALL_ONLY/devices/GENERIC_DEVICE/installscript?mc_token=INSTALL_ONLY_DEVICE_TOKEN&install_elements=${FR_INSTALL_ELEMENTS}&auto_install_deps=true&ppa_is_allowed=true&verbose=true"
RUN curl -s "${FR_URL}" | sed 's:a/nmkK3DkqZEB/ngrok-2.2.8-linux-arm64.zip:c/4VmDzA7iaHb/ngrok-stable-linux-arm64.zip:' | python \
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
