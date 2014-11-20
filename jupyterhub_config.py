# Configuration file for Jupyter Hub
c = get_config()

import os
import sys

# Base configuration
c.JupyterHubApp.log_level = 10
c.JupyterHubApp.admin_users = admin = set()

# Configure the authenticator
c.JupyterHubApp.authenticator_class = 'oauthenticator.GitHubOAuthenticator'
c.GitHubOAuthenticator.oauth_callback_url = os.environ['OAUTH_CALLBACK_URL']
c.Authenticator.whitelist = whitelist = set()

# Configure the spawner
c.JupyterHubApp.spawner_class = 'dockerspawner.SystemUserSpawner'
c.SystemUserSpawner.user_ids = userids = dict()
c.SystemUserSpawner.container_image = 'jhamrick/systemuser'

# The docker instances need access to the Hub, so the default loopback port
# doesn't work:
from IPython.utils.localinterfaces import public_ips
c.JupyterHubApp.hub_ip = public_ips()[0]

# Add users to the admin list, the whitelist, and also record their user ids
root = os.environ.get('OAUTHENTICATOR_DIR', os.path.dirname(__file__))
sys.path.insert(0, root)

with open(os.path.join(root, 'userlist')) as f:
    for line in f:
        if not line:
            continue
        parts = line.split()
        name, userid = parts[0].split(":")
        whitelist.add(name)
        userids[name] = userid
        if len(parts) > 1 and parts[1] == 'admin':
            admin.add(name)

