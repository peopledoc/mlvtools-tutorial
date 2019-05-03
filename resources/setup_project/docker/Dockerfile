FROM python:3.6

RUN apt-get update && apt-get install -y tree \
                                         nano \
                                         vim \
                                         virtualenv \
                                         python3-dev

RUN git config --global user.name tuto_user
RUN git config --global user.email tuto_user@example.com

WORKDIR /tuto