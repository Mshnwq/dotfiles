#!/bin/env bash


# Find all executable files and extract their filenames exclude .py duplicates
scripts=$(find "$HOME/.config/bspwm/src/executer_scripts" -type f -executable \
! -path "*/.venv/*" ! -path "*/.old/*" -printf "%f\n" | \
awk -F. '{
  if ($2 == "sh") sh_files[$1] = 1;
  else if ($2 == "py") py_files[$1] = 1;
}
END {
  for (name in sh_files) {
    print name ".sh";  # Keep .sh files
  }
  for (name in py_files) {
    if (!(name in sh_files)) print name ".py";  # Only keep .py if no .sh exists
  }
}')

# Pass the scripts to rofi for selection
selected=$(echo "$scripts" | rofi -dmenu -theme "$HOME/.config/bspwm/src/rofi-themes/Executer.rasi")

# Exit if no script is selected
[ -z "$selected" ] && exit 0

# Path to the selected script
script="$HOME/.config/bspwm/src/executer_scripts/$selected"

# Check if the script requires input
if grep -q "#INPUT_REQUIRED" "$script"; then
    # Prompt the user for input using `rofi`
    user_input=$(rofi -dmenu -theme "$HOME/.config/bspwm/src/rofi-themes/Input.rasi" -p "Enter input for $selected: ")
    
    # Run the script with the input
    "$script" "$user_input"
else
    # Run the script normally if no input is required
    "$script"
fi
