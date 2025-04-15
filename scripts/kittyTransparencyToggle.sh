
#!/bin/bash

# Path to the Kitty config file
KITTY_CONFIG="$HOME/.config/kitty/kitty.conf"

# Transparency values
OPAQUE="background_opacity 1.0"
TRANSPARENT="background_opacity 0.8"

# Check current transparency and toggle
if grep -q "$TRANSPARENT" "$KITTY_CONFIG"; then
    # Switch to opaque
    sed -i '' "s/$TRANSPARENT/$OPAQUE/" "$KITTY_CONFIG"
    echo "Switched to opaque background."
else
    # Switch to transparent
    sed -i '' "s/$OPAQUE/$TRANSPARENT/" "$KITTY_CONFIG"
    echo "Switched to transparent background."
fi

# Get the active Kitty window ID
KITTY_WINDOW_ID=$(kitty @ ls | grep -Eo '"id": [0-9]+' | head -n 1 | awk '{print $2}')

if [ -n "$KITTY_WINDOW_ID" ]; then
    # Reload colors using the specific window ID
    kitty @ --to "unix:/tmp/kitty-$KITTY_WINDOW_ID" set-colors --reload "$KITTY_CONFIG"
    echo "Kitty config reloaded for window ID $KITTY_WINDOW_ID."
else
    echo "Kitty is not running or no active window found."
fi

