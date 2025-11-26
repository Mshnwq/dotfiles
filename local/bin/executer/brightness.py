import argparse
import os
import subprocess

# Create an argument parser
parser = argparse.ArgumentParser(description="Brightness Adjuster")
# Add an argument for brightness adjustment
parser.add_argument("brightness_direction", choices=["up", "down"])
# Parse the command-line arguments
args = parser.parse_args()

home = os.path.expanduser("~")
rice_f = os.path.join(home, ".config/dots/.rice")
with open(rice_f, "r") as f:
    rice = f.read().strip()
icon = os.path.join(home, f".config/dots/rices/{rice}/assets/brightness.png")

# Determine the direction of the brightness adjustment
if args.brightness_direction == "up":
    # Increases brightness by 10%
    subprocess.run(["brightnessctl", "-e4", "-n2", "set", "5%+"])
    # Gets new current brightness
    current_brightness = int(
        subprocess.run(
            ["brightnessctl", "get"], capture_output=True, text=True
        ).stdout.strip()
    )
    # Calculate brightness percentage
    brightness_percentage = int(current_brightness / 24000 * 100)
    # Display notification using dunstify
    existing_notification = os.system(
        f'dunstify -p -a "brightness" -r 12345 -h int:value:"{brightness_percentage}" "{brightness_percentage}%" --icon={icon}'
    )
    if existing_notification == 0:
        os.system(
            f'dunstify -p -u normal -r 12345 -h int:value:"{brightness_percentage}" "{brightness_percentage}%" --icon={icon} >/dev/null'
        )
    else:
        os.system(
            f'dunstify -p -a brightness -r 12345 -h int:value:"{brightness_percentage}" "{brightness_percentage}%" --icon={icon} >/dev/null'
        )
elif args.brightness_direction == "down":
    subprocess.run(["brightnessctl", "-e4", "-n2", "set", "5%-"])
    current_brightness = int(
        subprocess.run(
            ["brightnessctl", "get"], capture_output=True, text=True
        ).stdout.strip()
    )
    brightness_percentage = int(current_brightness / 24000 * 100)
    existing_notification = os.system(
        f'dunstify -p -a "brightness" -r 12345 -h int:value:"{brightness_percentage}" "{brightness_percentage}% --icon={icon}'
    )
    if existing_notification == 0:
        os.system(
            f'dunstify -p -u normal -r 12345 -h int:value:"{brightness_percentage}" "{brightness_percentage}%" --icon={icon} >/dev/null'
        )
    else:
        os.system(
            f'dunstify -p -a brightness -r 12345 -h int:value:"{brightness_percentage}" "{brightness_percentage}%" --icon={icon} >/dev/null'
        )
else:
    print("Invalid argument for brightness direction.", end="")
    print("Please enter 'up' or 'down'.")
