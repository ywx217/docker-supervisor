# Benchmark for MongoDB used as a message queue
FROM debian:jessie
MAINTAINER Wenxuan Yang "ywx217@gmail.com"

# make sure the package repository is up to date
ADD sources.list /etc/apt/sources.list


# install supervisord and sshd
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        supervisor \
        openssh-server \
        htop \
    && rm -rf /var/lib/apt/lists/*

ENV HOME /root

# supervisor installation && 
# create directory for child images to store configuration in
RUN mkdir -p /var/log/supervisor \
    && mkdir -p /etc/supervisor/conf.d \
    && mkdir /var/run/sshd \
    && echo 'root:root' | chpasswd \
    && sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

EXPOSE 22
EXPOSE 9001

# supervisor base configuration
ADD supervisor.conf /etc/supervisor.conf
ADD sshd.conf /etc/supervisor/conf.d/sshd.conf

# default command
CMD ["supervisord", "-c", "/etc/supervisor.conf"]
