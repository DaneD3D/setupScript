#!/bin/bash

# Cross-platform dev environment setup (Ubuntu + macOS)

echo "🚀 Starting development environment setup..."

# Function to install packages on Ubuntu
setup_ubuntu() {
    echo "🟢 Detected Ubuntu. Updating packages..."
    sudo apt update && sudo apt upgrade -y

    echo "🛠 Installing build tools (build-essential)..."
    sudo apt install -y build-essential

    echo "🐚 Installing Zsh..."
    if ! command -v zsh &> /dev/null; then
        sudo apt install -y zsh
    fi

    install_oh_my_zsh
    install_python_ubuntu
    install_pipx_ubuntu
    install_neovim_ubuntu
    install_lazyvim
    set_default_shell_to_zsh
    install_ranger_fm
}

# Function to install packages on macOS
setup_macos() {
    echo "🍎 Detected macOS."

    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        echo "📦 Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "📦 Homebrew already installed. Updating..."
        brew update
    fi

    echo "🐚 Installing Zsh..."
    if ! command -v zsh &> /dev/null; then
        brew install zsh
    fi

    install_oh_my_zsh
    install_python_macos
    install_pipx_macos
    install_neovim_macos
    install_lazyvim
    set_default_shell_to_zsh
    install_ranger_fm
}

# Function to install Oh My Zsh
install_oh_my_zsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "🧙 Installing Oh My Zsh..."
        RUNZSH=no CHSH=no sh -c \
        "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
        echo "✅ Oh My Zsh is already installed."
    fi
}

# Function to install Python on Ubuntu
install_python_ubuntu() {
    echo "🐍 Installing Python 3..."
    if ! command -v python3 &> /dev/null; then
        sudo apt install -y python3 python3-pip
    else
        echo "✅ Python 3 is already installed."
    fi
}

# Function to install Python on macOS
install_python_macos() {
    echo "🐍 Installing Python 3..."
    if ! command -v python3 &> /dev/null; then
        brew install python
    else
        echo "✅ Python 3 is already installed."
    fi
}

# Function to install pipx on Ubuntu
install_pipx_ubuntu() {
    echo "📦 Installing pipx..."
    if ! command -v pipx &> /dev/null; then
        sudo apt install -y pipx
        python3 -m pipx ensurepath
    else
        echo "✅ pipx is already installed."
    fi
}

# Function to install pipx on macOS
install_pipx_macos() {
    echo "📦 Installing pipx..."
    if ! command -v pipx &> /dev/null; then
        brew install pipx
    else
        echo "✅ pipx is already installed."
    fi

    pipx ensurepath
}

# Function to install Neovim on Ubuntu
install_neovim_ubuntu() {
    echo "📝 Installing Neovim..."
    if ! command -v nvim &> /dev/null; then
        sudo apt install -y neovim
    else
        echo "✅ Neovim is already installed."
    fi
}

# Function to install Neovim on macOS
install_neovim_macos() {
    echo "📝 Installing Neovim..."
    if ! command -v nvim &> /dev/null; then
        brew install neovim
    else
        echo "✅ Neovim is already installed."
    fi
}

# Function to install LazyVim config
install_lazyvim() {
    echo "🧪 Setting up LazyVim..."

    if [ -d "$HOME/.config/nvim" ]; then
        echo "⚠️  Neovim config directory already exists. Skipping LazyVim clone."
    else
        echo "📦 Installing LazyVim starter config..."
        git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"
        rm -rf "$HOME/.config/nvim/.git"
        echo "✅ LazyVim installed."
    fi
}

# Function to install ranger-fm using pipx
install_ranger_fm() {
    echo "📦 Installing ranger-fm using pipx..."
    
    if ! pipx list | grep -q ranger-fm; then
        pipx install ranger-fm
        echo "✅ ranger-fm installed."
    else
        echo "✅ ranger-fm is already installed."
    fi
}

# Function to force set Zsh as the default shell
set_default_shell_to_zsh() {
    echo "🔄 Changing default shell to Zsh..."
    ZSH_PATH=$(command -v zsh)
    if [ -n "$ZSH_PATH" ]; then
        chsh -s "$ZSH_PATH"
        echo "✅ Default shell changed to Zsh."
        echo "ℹ️ You may need to log out and back in for changes to take effect."
    else
        echo "❌ Zsh is not installed or not found in PATH."
    fi
}

# Detect OS and run appropriate setup
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    setup_ubuntu
elif [[ "$OSTYPE" == "darwin"* ]]; then
    setup_macos
else
    echo "❌ Unsupported OS: $OSTYPE"
    exit 1
fi

echo "✅ Setup complete."
