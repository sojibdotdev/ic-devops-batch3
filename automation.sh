#!/bin/bash

# Script: setup_node_project.sh
# Purpose: Automate Node.js project setup for freshers
# Author: Samsuddoha Sojib

# Check if SSH is set up
if ! [ -f ~/.ssh/id_rsa.pub ]; then
  echo "❌ SSH key not found. Generating a new SSH key..."
  ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -N "" -f ~/.ssh/id_rsa
  echo "✅ SSH key generated. Add the following public key to your Git repository:"
  cat ~/.ssh/id_rsa.pub
  exit 1
fi

# Clone the repository
REPO_URL="git@github.com:your-org/your-nodejs-repo.git"
TARGET_DIR="node_project"

echo "🔄 Cloning the repository..."
if [ -d "$TARGET_DIR" ]; then
  echo "✅ Repository already cloned. Pulling the latest changes..."
  cd "$TARGET_DIR" && git pull origin main
else
  git clone "$REPO_URL" "$TARGET_DIR"
  echo "✅ Repository cloned to $TARGET_DIR."
  cd "$TARGET_DIR"
fi

# Check for Node.js installation
if ! command -v node &> /dev/null; then
  echo "❌ Node.js is not installed. Installing Node.js..."
  curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
  sudo apt-get install -y nodejs
  echo "✅ Node.js installed successfully."
else
  echo "✅ Node.js is already installed. Version: $(node -v)"
fi

# Check for npm (Node Package Manager)
if ! command -v npm &> /dev/null; then
  echo "❌ npm is not installed. Please check your Node.js installation."
  exit 1
else
  echo "✅ npm is installed. Version: $(npm -v)"
fi

# Install project dependencies
echo "📦 Installing project dependencies..."
npm install
echo "✅ Dependencies installed."

# Run the development server
if [ -f "package.json" ]; then
  echo "🚀 Starting the development server..."
  npm run dev
else
  echo "⚠️ No package.json found. Unable to start the server."
fi

# Final steps
echo "🎉 Setup completed. The development server should be running!"
echo "👉 Use 'npm run dev' to restart the server if needed."
