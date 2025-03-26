#!/bin/bash

# Check if the user provided an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <path_to_directory>"
    exit 1
fi

# Assign the argument to a variable
TARGET_DIR="$1"

# Ensure the provided path exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory '$TARGET_DIR' does not exist."
    exit 1
fi

# Apply permissions
find "$TARGET_DIR" -type d -exec chmod g+rx {} \;
find "$TARGET_DIR" -type f -exec chmod g+r {} \;

echo "Permissions updated successfully for '$TARGET_DIR'."

exit 0
