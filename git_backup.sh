#!/bin/bash
#
# Author: Simon Rydell
# Date: 1 May 2018
#
# Store backup of directory ~/Dokument/Forskning using git.
# Backups are stored in a private git repository

# Log the time of the push
TIMEOFBACKUP=$(date +%c)

if [[ "$(git status --porcelain)" ]]; then
    # Changes have been made
    # Change to the right directory
    cd $HOME/Dokument/Forskning

    # Add the changed files
    git add .

    # Set commit message
    git commit -m "Automatic backup: $TIMEOFBACKUP"
    
    # Push the change to the remote server
    git push
fi

# Free up the variable name
unset TIMEOFBACKUP
