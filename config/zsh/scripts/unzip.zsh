function unzips() {
  for zip in *.zip; do
    dir="${zip%.zip}"    # Remove the .zip extension to create a directory name
    mkdir "$dir"         # Create the directory
    unzip "$zip" -d "$dir"  # Extract the contents into the directory
  done
}
