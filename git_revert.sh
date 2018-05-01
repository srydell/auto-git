#!/usr/bin/env bash
#
# Author: Simon Rydell
# Date: 1 May 2018
# Input: Path to a directory under git source control
#
# Save current directory structure to a time stamped branch.
# Restore latest backup of directory from local using git.

# Check that input is a directory
if [ -d "$1" ]; then
	dir_under_source_control="$1"
else
	printf "Input was not a directory. Given: %s" "$1"
	exit 1
fi

# Change to the right directory
cd "$dir_under_source_control" || exit

# Get the current time
# Format: YYYY-MM-DD_HH-mm-ss
time_of_backup=$(date +%x_%H-%M-%S)

# Get the latest commit hash
latest_sha=$(git log | head -n1 | sed 's/^commit //')

# This will be the branch name AND the commit message on that branch
save_message="Saved_state_from_$time_of_backup"

# Create a branch where we will save what we want to revert from
# It is garanteed to be unique due to $time_of_backup
git checkout -b "$save_message"

# Save what we will revert from
git add .
git commit -m "$save_message"

# Push our saved state
git push --set-upstream origin "$save_message"

# Go back to master branch
git checkout master

# Revert back to the latest commit before save. 
# NOTE: On its own this is dangerous,
#	here it's safe since we trust the previous save
git reset --hard "$latest_sha"

# Free up the variable names
unset dir_under_source_control
unset time_of_backup
unset latest_sha
unset save_message
