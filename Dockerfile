FROM jhamrick/oauthenticator

# Install dockerspawner
RUN pip3 install docker-py
RUN pip3 install git+git://github.com/jupyter/dockerspawner.git

# Add variable to allow connecting to the docker host
ENV DOCKER_HOST unix://docker.sock

# Replace existing jupyterhub config
ADD jupyterhub_config.py /srv/jupyterhub/jupyterhub_config.py

# Replace existing user list
WORKDIR /srv/oauthenticator
ONBUILD ADD userlist /srv/oauthenticator/userlist
ONBUILD RUN chmod 700 /srv/oauthenticator
