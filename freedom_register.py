import os
import json
import logging 
import subprocess

from freedomrobotics.management import register_initd_service
from freedomrobotics.management import register_systemd_service

CREDENTIALS_PATH = os.path.expanduser("~/.config/freedomrobotics/credentials")
CREDENTIALS_DIR = os.path.dirname(CREDENTIALS_PATH)

def get_env_var(var):
    return subprocess.check_output("echo $" + var, shell=True).strip()

def execute(cmd):
    try:
        return subprocess.check_output(cmd, shell=True).strip()
    except Exception as e:
        return None

if __name__ == "__main__":

    logging.basicConfig(level=logging.DEBUG)
    logger = logging.getLogger(__name__)

    credentials = {
        "account": get_env_var("FR_ACCOUNT"),
        "device": get_env_var("FR_DEVICE"),
        "token": get_env_var("FR_TOKEN"),
        "secret": get_env_var("FR_SECRET"),
        "install_elements": get_env_var("FR_INSTALL_ELEMENTS").split(",")
        }

    if not os.path.exists(CREDENTIALS_DIR):
        os.makedirs(CREDENTIALS_DIR)

    with open(CREDENTIALS_PATH, 'w') as f:
        f.write(json.dumps(credentials, indent=4))

    systemd_pid = execute("pidof systemd")
    logger.debug("PID of Systemd: " + str(systemd_pid))

    # Try to register the service for 
    register_initd_service.install(logger)
