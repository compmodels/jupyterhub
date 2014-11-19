# Configuration file for Jupyter Hub

c = get_config()

c.JupyterHubApp.log_level = 10
c.JupyterHubApp.authenticator_class = 'oauthenticator.LocalGitHubOAuthenticator'
c.JupyterHubApp.spawner_class = 'systemuserspawner.SystemUserSpawner'
c.SystemUserSpawner.container_image = "jupyter/systemuser"

# The docker instances need access to the Hub, so the default loopback port doesn't work:
from IPython.utils.localinterfaces import public_ips
c.JupyterHubApp.hub_ip = public_ips()[0]

c.Authenticator.whitelist = whitelist = set()
c.JupyterHubApp.admin_users = admin = set()
c.SystemUserSpawner.user_ids = userids = dict()

import os
import sys

join = os.path.join

here = os.path.dirname(__file__)
root = os.environ.get('OAUTHENTICATOR_DIR', here)
sys.path.insert(0, root)

with open(join(root, 'userlist')) as f:
    for line in f:
        if not line:
            continue
        parts = line.split()
        name, userid = parts[0].split(":")
        whitelist.add(name)
        userids[name] = userid
        if len(parts) > 1 and parts[1] == 'admin':
            admin.add(name)

c.GitHubOAuthenticator.oauth_callback_url = os.environ['OAUTH_CALLBACK_URL']

# ssl config
ssl = join(root, 'ssl')
keyfile = join(ssl, 'ssl.key')
certfile = join(ssl, 'ssl.cert')
if os.path.exists(keyfile):
    c.JupyterHubApp.ssl_key = keyfile
if os.path.exists(certfile):
    c.JupyterHubApp.ssl_cert = certfile
