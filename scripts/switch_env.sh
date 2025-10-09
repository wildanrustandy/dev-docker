#!/bin/bash

# Script to switch between different environment configurations

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_TEMPLATE_DIR="$SCRIPT_DIR/../envs"

# Function to display usage
usage() {
    echo "Usage: $0 <environment>"
    echo ""
    echo "Available environments:"
    echo "  equip      - Switch to equip environment"
    echo "  odoo14     - Switch to odoo14 environment" 
    echo "  equip_prj  - Switch to equip_prj environment"
    echo "  list       - List all available environment files"
    echo "  show       - Show current environment"
    echo ""
    echo "Example: $0 equip"
    exit 1
}

# Function to list available environment files
list_envs() {
    echo "Available environment files:"
    for file in "$ENV_TEMPLATE_DIR"/*.env; do
        if [ -f "$file" ]; then
            env_name=$(basename "$file" .env)
            if [ -f "$SCRIPT_DIR/../.env" ] && diff -q "$file" "$SCRIPT_DIR/../.env" >/dev/null 2>&1; then
                echo "  * $env_name (active)"
            else
                echo "    $env_name"
            fi
        fi
    done
}

# Function to show current environment
show_current() {
    if [ -f "$SCRIPT_DIR/../.env" ]; then
        # Try to identify which environment is currently active
        for file in "$ENV_TEMPLATE_DIR"/*.env; do
            if [ -f "$file" ] && diff -q "$file" "$SCRIPT_DIR/../.env" >/dev/null 2>&1; then
                env_name=$(basename "$file" .env)
                echo "Current environment: $env_name"
                return
            fi
        done
        echo "Current environment: custom (not matching any template file)"
    else
        echo "Current environment: none (.env file does not exist)"
    fi
}

# Check if no arguments provided
if [ $# -eq 0 ]; then
    usage
fi

# Get the environment name
ENV_NAME="$1"

case "$ENV_NAME" in
    list)
        list_envs
        ;;
    show)
        show_current
        ;;
    equip|odoo14|equip_prj)
        ENV_FILE="$ENV_TEMPLATE_DIR/$ENV_NAME.env"
        
        if [ ! -f "$ENV_FILE" ]; then
            echo "Error: Environment file $ENV_FILE does not exist"
            echo ""
            list_envs
            exit 1
        fi
        
        # Copy the template file to .env
        cp "$ENV_FILE" "$SCRIPT_DIR/../.env"
        echo "Switched to $ENV_NAME environment"
        ;;
    *)
        echo "Error: Unknown environment '$ENV_NAME'"
        echo ""
        list_envs
        echo ""
        usage
        ;;
esac