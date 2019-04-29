FROM debian:stretch
RUN apt-get update && \
    apt-get -y install openssh-server git vim && \
    mkdir -p /var/run/sshd


RUN useradd -d /home/git -m -s /bin/bash git


RUN mkdir /home/git/.ssh && chmod 700 /home/git/.ssh
COPY pub_key /home/git/.ssh/authorized_keys
RUN chmod 600 /home/git/.ssh/authorized_keys
RUN chown git: -R /home/git/.ssh
RUN mkdir -p /srv/git/test_dvc_remote.git
RUN cd /srv/git/test_dvc_remote.git/ && git init --bare
RUN chown git: /srv/git/ -R


CMD ["/usr/sbin/sshd", "-D"]