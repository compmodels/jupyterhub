# Configuration file for Jupyter Hub
c = get_config()

import os
import sys

# Base configuration
c.JupyterHub.log_level = 10
c.JupyterHub.admin_users = admin = set()
c.JupyterHub.db_url = 'sqlite:////srv/jupyterhub_db/jupyterhub.sqlite'

# Configure the authenticator
c.JupyterHub.authenticator_class = 'docker_oauth.DockerOAuthenticator'
c.DockerOAuthenticator.oauth_callback_url = os.environ['OAUTH_CALLBACK_URL']
c.DockerOAuthenticator.create_system_users = True
c.Authenticator.whitelist = whitelist = set()

# Configure the spawner
c.JupyterHub.spawner_class = 'dockerspawner.SystemUserSpawner'
c.SystemUserSpawner.container_image = 'jhamrick/systemuser'

# The docker instances need access to the Hub, so the default loopback port
# doesn't work:
from IPython.utils.localinterfaces import public_ips
c.JupyterHub.hub_ip = public_ips()[0]

# Add users to the admin list, the whitelist, and also record their user ids
root = os.environ.get('OAUTHENTICATOR_DIR', os.path.dirname(__file__))
sys.path.insert(0, root)

with open(os.path.join(root, 'userlist')) as f:
    for line in f:
        if line.isspace():
            continue
        parts = line.split()
        name = parts[0]
        whitelist.add(name)
        if len(parts) > 1 and parts[1] == 'admin':
            admin.add(name)
