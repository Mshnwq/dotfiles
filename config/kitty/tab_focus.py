import logging
import os
import subprocess
from typing import Any

from kitty.boss import Boss
from kitty.window import Window

# Configure logging
LOG_FILE = "/tmp/kitty_focus_change.log"
logging.basicConfig(
    filename=LOG_FILE,
    level=logging.DEBUG,
    format="%(asctime)s - %(levelname)s - %(message)s",
)

FLAG_FILE = "/tmp/.kitty-bar-status"


def update_flag(state: str) -> None:
    """Update the flag file with the given state."""
    with open(FLAG_FILE, "w") as f:
        f.write(state)
    logging.debug(f"Updated flag file to: {state}")


def get_flag_state() -> str:
    """Read the current flag state from the file."""
    if not os.path.exists(FLAG_FILE):
        update_flag("show")  # Default state
    with open(FLAG_FILE, "r") as f:
        state = f.read().strip()
    logging.debug(f"Current flag state: {state}")
    return state


# def send_ydotool_command(key: str) -> None:
#    """Send a key command using ydotool."""
#    try:
#        subprocess.run(["ydotool", "key", key], check=True)
#        logging.info(f"Sent ydotool command: {key}")
#    except subprocess.CalledProcessError as e:
#        logging.error(f"ydotool command failed: {e}")


def send_ydotool_command(key_sequence: str) -> None:
    """Send a key command using ydotool with improved error logging."""
    key_args = (
        key_sequence.strip().split()
    )  # Split the key sequence into separate arguments
    cmd = ["ydotool", "key"] + key_args
    # Set environment with the custom socket
    env = os.environ.copy()
    env["YDOTOOL_SOCKET"] = "/run/user/1000/ydotool_socket"
    logging.debug(f"Running command: {' '.join(cmd)}")
    try:
        result = subprocess.run(
            cmd, check=True, capture_output=True, text=True, env=env
        )
        logging.info(f"ydotool stdout: {result.stdout}")
        if result.stderr:
            logging.warning(f"ydotool stderr: {result.stderr}")
    except subprocess.CalledProcessError as e:
        logging.error(f"ydotool command failed with exit code {e.returncode}")
        logging.error(f"Command: {' '.join(e.cmd)}")
        logging.error(f"stdout: {e.stdout}")
        logging.error(f"stderr: {e.stderr}")


def on_focus_change(boss: Boss, window: Window, data: dict[str, Any]) -> None:
    """Handles focus change in Kitty and updates the UI accordingly."""
    if not window:
        logging.warning("No active window detected.")
        return

    flag_state = get_flag_state()
    tab_id = window.id
    tab_title = window.title

    logging.debug(f"window {window}")
    logging.info(f"Focus changed to: {tab_title}")

    if tab_title == "sh":
        return

    if tab_id == 1:
        if flag_state == "show":
            logging.info(f"Hiding bar for {tab_title}")
            send_ydotool_command("97:1 54:1 35:1 97:0 54:0 35:0")  # Hide
            update_flag("hidden")
        else:
            logging.info(f"Not Hiding for {tab_title}")
    else:
        if flag_state == "hidden":
            logging.info(f"Showing bar for {tab_title}")
            send_ydotool_command("97:1 54:1 22:1 97:0 54:0 22:0")  # Show
            update_flag("show")
        else:
            logging.info(f"Not Showing for {tab_title}")
