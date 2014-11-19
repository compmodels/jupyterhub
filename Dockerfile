FROM jhamrick/oauthenticator

# Set up dockerspawner
RUN pip3 install docker-py
ADD dockerspawner /srv/dockerspawner
WORKDIR /srv/dockerspawner
RUN python3 setup.py install

# Add variable to allow connecting to the docker host
ENV DOCKER_HOST unix://docker.sock

# Replace existing jupyterhub config
ADD jupyterhub_config.py /srv/jupyterhub/jupyterhub_config.py

# Replace existing user list
WORKDIR /srv/oauthenticator
ONBUILD ADD userlist /srv/oauthenticator/userlist
ONBUILD RUN chmod 700 /srv/oauthenticator
