FROM jhamrick/oauthenticator

# Set up dockerspawner
ADD dockerspawner/dockerspawner.py /srv/oauthenticator/dockerspawner.py
ADD dockerspawner/systemuserspawner.py /srv/oauthenticator/systemuserspawner.py
ENV DOCKER_HOST unix://docker.sock
RUN pip3 install docker-py

# Replace existing jupyterhub config
ADD jupyterhub_config.py /srv/jupyterhub/jupyterhub_config.py

# Replace existing user list
ONBUILD ADD userlist /srv/oauthenticator/userlist
ONBUILD RUN chmod 700 /srv/oauthenticator
