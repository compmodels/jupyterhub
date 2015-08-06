import json
import os

from tornado import gen

from jupyterhub.auth import LocalAuthenticator
from oauthenticator import GoogleAppsOAuthenticator


class DockerAuthenticator(LocalAuthenticator):
    """A version that performs local system user creation from within a
    docker container.

    """

    def system_user_exists(self, user):
        # user_id is stored in state after looking it up
        return user.state and 'user_id' in user.state

    @gen.coroutine
    def add_system_user(self, user):
        """Add a new user.

        This adds the user to the whitelist, and creates a system user by
        accessing a simple REST api.

        """
        homedir = os.path.join('/', 'home', user.name)
        os.mkdir(homedir)
        os.chown(homedir, 2000, 2000)
        self.log.info("Created home directory for user %s", user.name)
        if user.state is None:
            user.state = {}
        user.state['user_id'] = 2000
        self.db.commit()


class DockerOAuthenticator(DockerAuthenticator, GoogleAppsOAuthenticator):
    """A version that mixes in local system user creation from within a
    docker container, and Google OAuthentication.

    """
    pass
