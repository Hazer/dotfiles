#!/bin/sh

# Get the current timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Define the backup directory with the timestamp
BACKUP_DIR="$HOME/backup-dotfiles/$TIMESTAMP"

# Create the backup directory
mkdir -p "$BACKUP_DIR"

# Check if any arguments were provided
if [ "$#" -eq 0 ]; then
    echo "Usage: $0 'path1 => ...' 'path2 => ...' ..."
    exit 1
fi

# Initialize a counter for copied files
copied_count=0

echo "\nCopying your current conflicting dotfiles to\n $BACKUP_DIR"

# Process the single argument containing all paths
while IFS= read -r line; do
    if [[ "$line" == LINK:* ]]; then
        # Extract the left-hand side of the '=>'
        dotpath=$(echo "$line" | sed 's/^LINK: *//; s/ => .*//')

        path_in_home="$HOME/$dotpath"

        # Check if the path exists
        if [ -e "$path_in_home" ]; then
            # Copy the file or directory to the backup directory
            cp -r "$path_in_home" "$BACKUP_DIR"
            echo "Copied: $path_in_home"
            ((copied_count++))
        else
            echo "Skipped: $path_in_home does not exist in ~/..."
        fi
    fi
done <<< "$1"

# Check if any files were copied
if [ "$copied_count" -eq 0 ]; then
    rm -rf "$BACKUP_DIR"
    echo "No backup needed, found no overwriting files."
else
    echo "Backup completed."
fi
