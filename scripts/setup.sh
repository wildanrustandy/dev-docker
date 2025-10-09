#!/bin/bash

# Setup script to install the environment switching functionality

echo "Setting up environment switching for dev-docker..."

# Function to add alias to shell profile
add_to_profile() {
    local profile_file="$1"
    local profile_name="$2"
    
    if [ -f "$profile_file" ]; then
        echo "Checking $profile_name for existing dev_env function..."
        
        # Check if the function already exists
        if grep -q "dev_env()" "$profile_file"; then
            echo "dev_env function already exists in $profile_file. Please update it manually with the following:"
            echo ""
            echo "dev_env() {"
            echo "    cd /Users/wildanrustandy/Dev/dev-docker && ./scripts/switch_env.sh \"\$1\""
            echo "}"
            echo ""
        else
            # Add the function
            echo "" >> "$profile_file"
            echo "# Dev-docker environment switcher" >> "$profile_file"
            echo "dev_env() {" >> "$profile_file"
            echo "    cd /Users/wildanrustandy/Dev/dev-docker && ./scripts/switch_env.sh \"\$1\"" >> "$profile_file"
            echo "}" >> "$profile_file"
            echo "Added dev_env function to $profile_file"
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
echo "Setup complete! You can now use the dev_env command from anywhere."

echo "To make the command available immediately, run:"
echo "  source ~/.zshrc  # if using zsh"
echo "  OR"
echo "  source ~/.bashrc # if using bash"