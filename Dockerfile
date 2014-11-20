FROM jupyter/jupyterhub

MAINTAINER Jessica Hamrick <jhamrick@berkeley.edu>

# Install dockerspawner and oauthenticator
RUN pip3 install docker-py
RUN pip3 install git+git://github.com/jupyter/dockerspawner.git
RUN pip3 install git+git://github.com/jhamrick/oauthenticator.git@make-package

# Add variable to allow connecting to the docker host
ENV DOCKER_HOST unix://docker.sock

# Create oauthenticator directory -- this is where we'll put the userlist later
RUN mkdir /srv/oauthenticator
WORKDIR /srv/oauthenticator
ENV OAUTHENTICATOR_DIR /srv/oauthenticator
RUN chmod 700 /srv/oauthenticator

ONBUILD ADD userlist /srv/oauthenticator/userlist
