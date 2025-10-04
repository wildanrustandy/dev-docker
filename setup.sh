#!/bin/bash

# Setup script to install the environment switching functionality

echo "Setting up environment switching for dev-docker..."

# Function to add alias to shell profile
add_to_profile() {
    local profile_file="$1"
    local profile_name="$2"
    
    if [ -f "$profile_file" ]; then
        echo "Checking $profile_name for existing alias..."
        
        # Check if the alias already exists
        if grep -q "alias switch-dev-env" "$profile_file"; then
            echo "Alias already exists in $profile_file"
        else
            # Add the alias
            echo "" >> "$profile_file"
            echo "# Dev-docker environment switcher" >> "$profile_file"
            echo "alias switch-dev-env='/Users/wildanrustandy/Dev/dev-docker/switch_env.sh'" >> "$profile_file"
            echo "Added alias to $profile_file"
        fi
    else
        echo "$profile_file does not exist, skipping..."
    fi
}

# Check for different shell profiles
add_to_profile "$HOME/.zshrc" ".zshrc"
add_to_profile "$HOME/.bashrc" ".bashrc" 
add_to_profile "$HOME/.bash_profile" ".bash_profile"

echo ""
echo "Setup complete! You can now:"
echo "1. Use the script directly: /Users/wildanrustandy/Dev/dev-docker/switch_env.sh equip"
echo "2. Or if you sourced your shell profile, use: switch-dev-env equip"
echo ""
echo "Available environments are stored in /Users/wildanrustandy/Dev/dev-docker/env-sample/"
echo "To make the alias available immediately, run:"
echo "  source ~/.zshrc  # if using zsh"
echo "  OR"
echo "  source ~/.bashrc # if using bash"