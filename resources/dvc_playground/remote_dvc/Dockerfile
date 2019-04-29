FROM debian:stretch
RUN apt-get update && \
    apt-get -y install openssh-server vim && \
    mkdir -p /var/run/sshd

RUN groupadd ssh_user
RUN useradd -g ssh_user -d /upload -s /bin/bash poney -p azerty
RUN mkdir -p /data/dvc/remote
RUN chown -R root:ssh_user /data/dvc
RUN chown -R poney:ssh_user /data/dvc/remote
RUN chmod ug+w -R /data/dvc/remote

COPY pub_key /tmp
RUN useradd -g ssh_user -m -d /home/dvc_user -s /bin/bash dvc_user && \
    mkdir -p /home/dvc_user/.ssh/ && \
    cat /tmp/pub_key > /home/dvc_user/.ssh/authorized_keys && \
    chown dvc_user:ssh_user -R /home/dvc_user && \
    chmod 644 /home/dvc_user/.ssh/authorized_keys


CMD ["/usr/sbin/sshd", "-D"]