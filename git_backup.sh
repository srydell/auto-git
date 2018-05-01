#!/bin/bash
#
# Author: Simon Rydell
# Date: 1 May 2018
#
# Store backup of directory in $1 using git.
# Backups are stored in a private git repository

# Check that there is only one input
# and that it is a directory
if [ "$#" -ne 1 ] && [ -d "$1" ]; then
	dir_under_source_control="$1"
else
	printf "Input was not a directory. Given: %s" "%1"
	exit 1
fi

# Log the time of the push
time_of_backup=$(date +%c)

# Change to the right directory (exit if failed)
cd "$dir_under_source_control" || exit

if [[ "$(git status --porcelain)" ]]; then
	# Changes have been made

	# Add the changed files
	git add .

	# Set commit message
	git commit -m "Automatic backup: $time_of_backup"

	# Push the change to the remote server
	git push
fi

# Free up the variable names
unset dir_under_source_control
unset time_of_backup
