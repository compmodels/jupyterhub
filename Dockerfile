FROM jupyter/jupyterhub

MAINTAINER Jessica Hamrick <jhamrick@berkeley.edu>

# Install dockerspawner and oauthenticator
RUN pip3 install docker-py
RUN pip3 install git+git://github.com/jupyter/dockerspawner.git
RUN pip3 install git+git://github.com/jupyter/oauthenticator.git

# Add variable to allow connecting to the docker host
ENV DOCKER_HOST unix://docker.sock

# Create oauthenticator directory -- this is where we'll put the userlist later
RUN mkdir /srv/oauthenticator
ENV OAUTHENTICATOR_DIR /srv/oauthenticator
RUN chmod 700 /srv/oauthenticator

# install docker_oauth
ADD https://raw.githubusercontent.com/jhamrick/docker-oauthenticator/master/docker_oauth.py /srv/oauthenticator/docker_oauth.py

ONBUILD ADD userlist /srv/oauthenticator/userlist

# set working directory to the jupyterhub directory
WORKDIR /srv/jupyterhub
