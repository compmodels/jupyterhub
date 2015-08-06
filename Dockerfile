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
RUN mkdir /srv/jupyterhub_config
WORKDIR /srv/jupyterhub_config
ADD swarmspawner.py /srv/jupyterhub_config/swarmspawner.py
ADD docker_oauth.py /srv/jupyterhub_config/docker_oauth.py
ADD jupyterhub_config.py /srv/jupyterhub_config/jupyterhub_config.py

# create /srv/jupyterhub_users directory (which is where we'll mount the userlist)
RUN mkdir /srv/jupyterhub_users

# set the working directory and the command
ENTRYPOINT ["jupyterhub"]