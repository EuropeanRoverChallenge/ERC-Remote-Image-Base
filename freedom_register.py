import os
import json
import logging

from freedomrobotics.management import register_initd_service

CREDENTIALS_PATH = os.path.expanduser("~/.config/freedomrobotics/credentials")
CREDENTIALS_DIR = os.path.dirname(CREDENTIALS_PATH)

if __name__ == "__main__":

    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    credentials = {
        "account": os.environ["FR_ACCOUNT"],
        "device": os.environ["FR_DEVICE"],
        "token": os.environ["FR_TOKEN"],
        "secret": os.environ["FR_SECRET"],
        "install_elements": os.environ["FR_INSTALL_ELEMENTS"].split(","),
    }

    if not os.path.exists(CREDENTIALS_DIR):
        os.makedirs(CREDENTIALS_DIR)

    with open(CREDENTIALS_PATH, "w") as f:
        f.write(json.dumps(credentials, indent=4))

    # Try to register the service
    register_initd_service.install(logger)
