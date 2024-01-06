#!/bin/bash

# Check if the script is provided with at least one argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

# Get the username from the command line argument
username=$1

# Echo the username
echo "Username: $username"