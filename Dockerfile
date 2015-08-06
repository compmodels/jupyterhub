FROM jupyter/jupyterhub

MAINTAINER Jessica Hamrick <jhamrick@berkeley.edu>

# We need to update pip, otherwise the version of requests that
# is installed by dockerspawner breaks things.
RUN pip3 install --upgrade pip

# Install dockerspawner and oauthenticator
RUN /usr/local/bin/pip3 install docker-py
RUN /usr/local/bin/pip3 install git+git://github.com/jupyter/dockerspawner.git
RUN /usr/local/bin/pip3 install git+git://github.com/ryanlovett/jh-google-oauthenticator.git

# Add variable to allow connecting to the docker swarm
ENV DOCKER_HOST https://127.0.0.1:2376

# add the userlist, spawner, and authenticator
ADD swarmspawner.py /srv/jupyterhub/swarmspawner.py
ADD docker_oauth.py /srv/jupyterhub/docker_oauth.py

# create /srv/jupyterhub_users directory (which is where we'll mount the userlist)
RUN mkdir /srv/jupyterhub_users