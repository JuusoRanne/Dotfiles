
#!/bin/bash

# Source directory
DOTFILES_DIR=~/Dotfiles

# Target directory
CONFIG_DIR=~/.config

# List of configurations to mirror
CONFIGS=("nvim" "zellij" "hypr")

# Ensure the ~/.config directory exists
mkdir -p "$CONFIG_DIR"

echo "Starting to mirror dotfiles..."

# Loop through the configurations
for config in "${CONFIGS[@]}"; do
  SOURCE="$DOTFILES_DIR/$config"
  TARGET="$CONFIG_DIR/$config"

  # Check if the source exists
  if [ -e "$SOURCE" ]; then
    # Remove the existing target if it's already a file/symlink
    if [ -L "$TARGET" ] || [ -e "$TARGET" ]; then
      echo "Removing existing $TARGET..."
      rm -rf "$TARGET"
    fi

    # Create a symlink from the source to the target
    echo "Creating symlink for $config..."
    ln -s "$SOURCE" "$TARGET"
  else
    echo "Warning: $SOURCE does not exist, skipping..."
  fi
done

echo "Dotfiles successfully mirrored!"
