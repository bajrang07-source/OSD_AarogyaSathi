#!/bin/bash

echo ""
echo "  ╔══════════════════════════════════════════╗"
echo "  ║        AarogyaSathi AI Health App        ║"
echo "  ║   Offline Rural Health Assistant — India ║"
echo "  ╚══════════════════════════════════════════╝"
echo ""

# Check if Python is installed
if ! command -v python3 &> /dev/null && ! command -v python &> /dev/null; then
    echo "  [ERROR] Python is not installed."
    echo ""
    echo "  Install it with:"
    echo "    macOS:  brew install python"
    echo "    Ubuntu: sudo apt install python3"
    echo ""
    exit 1
fi

PYTHON=$(command -v python3 || command -v python)

echo "  [OK] Python found. Starting server..."
echo ""
echo "  ┌─────────────────────────────────────────┐"
echo "  │  App is running at:                     │"
echo "  │                                         │"
echo "  │      http://localhost:3000              │"
echo "  │                                         │"
echo "  │  Press Ctrl+C to stop.                  │"
echo "  └─────────────────────────────────────────┘"
echo ""

# Open browser
sleep 1
if command -v xdg-open &> /dev/null; then
    xdg-open http://localhost:3000 &   # Linux
elif command -v open &> /dev/null; then
    open http://localhost:3000 &       # macOS
fi

# Serve the web build
$PYTHON -m http.server 3000 --directory build/web
