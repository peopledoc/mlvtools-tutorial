FROM python:3.6
ARG USER_NAME
RUN apt-get update && \
    apt-get -y install openssh-client vim git tree && \
    mkdir -p /var/run/sshd

COPY private_key /tmp/

RUN useradd -d /home/$USER_NAME -m -s /bin/bash $USER_NAME

RUN mkdir /home/$USER_NAME/.ssh
COPY private_key /home/$USER_NAME/.ssh/id_rsa
RUN chown $USER_NAME:$USER_NAME -R /home/$USER_NAME/
RUN chmod 600 /home/$USER_NAME/.ssh/id_rsa

USER $USER_NAME
ENV PATH=$PATH:/home/$USER_NAME/.local/bin/
RUN pip install --user dvc paramiko

RUN git config --global user.name $(whoami)
RUN git config --global user.email $(whoami)@example.com
COPY resources /resources

EXPOSE 22