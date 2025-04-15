#!/bin/bash

# Function to display help
show_help() {
    echo
    echo "Phoenix AI Control Setup Script"
    echo "-------------------------------"
    echo "Usage:"
    echo "    sudo ./setup_phoenix_ai_control_mac.sh [--managedByEmail <email>] [--allowedUsers <user1,user2,...>]"
    echo
    echo "Options:"
    echo "    --managedByEmail   Optional. Admin email who manages AI policy."
    echo "    --allowedUsers     Optional. Comma-separated list of macOS usernames allowed to use AI."
    echo
    echo "Examples:"
    echo "    sudo ./setup_phoenix_ai_control_mac.sh --managedByEmail admin@example.com"
    echo "    sudo ./setup_phoenix_ai_control_mac.sh --allowedUsers alice,bob"
    echo "    sudo ./setup_phoenix_ai_control_mac.sh --managedByEmail admin@example.com --allowedUsers alice,bob"
    echo
    echo "Help:"
    echo "    ./setup_phoenix_ai_control_mac.sh --help"
    echo
    echo "NOTE: sudo privileges are required to make changes,"
    echo "      but not to view this help information."
    echo
    exit 1
}

# Check for help flags first, before sudo check
if [ "$1" == "--help" ]; then
    show_help
fi

# Check if script is run with sudo/as root
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run with sudo privileges to make changes."
    echo "Please run: sudo $0 $*"
    echo "Run with --help for usage information."
    exit 1
fi

# Parse arguments
managedByEmail=""
allowedUsers=""

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        --help)
            show_help
            ;;
        --managedByEmail)
            managedByEmail="$2"
            shift 2
            ;;
        --allowedUsers)
            allowedUsers="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            ;;
    esac
done

# Target directory and file
TARGET_DIR="/Library/Application Support/Phoenix AI Control"
CONFIG_FILE="$TARGET_DIR/config.json"

# Create directory if it doesn't exist
if [ ! -d "$TARGET_DIR" ]; then
    mkdir -p "$TARGET_DIR"
fi

# Start creating the JSON content
json_content='{'
json_content+='"disableAI": true'

# Add managedByEmail if specified
if [ -n "$managedByEmail" ]; then
    json_content+=',"managedByEmail": "'"$managedByEmail"'"'
fi

# Add allowedUsers if specified
if [ -n "$allowedUsers" ]; then
    json_content+=',"allowedUsers": ['

    # Convert comma-separated list to array
    IFS=',' read -ra USERS <<< "$allowedUsers"

    first=true
    for user in "${USERS[@]}"; do
        if $first; then
            json_content+='"'"$user"'"'
            first=false
        else
            json_content+=',"'"$user"'"'
        fi
    done

    json_content+=']'
fi

json_content+='}'

# Write the JSON to the config file
echo "$json_content" > "$CONFIG_FILE"

# Set appropriate permissions: root:wheel with read access for everyone
chown root:wheel "$CONFIG_FILE"
chmod 644 "$CONFIG_FILE"

echo
echo "Phoenix AI control config written to:"
echo "$CONFIG_FILE"
echo
echo "Permissions set to allow only root to write, but everyone to read."
