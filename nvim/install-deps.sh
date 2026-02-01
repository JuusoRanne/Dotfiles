#!/usr/bin/env bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "\n${BLUE}===================================${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}===================================${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}! $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [ -f /etc/arch-release ]; then
        echo "arch"
    elif [ -f /etc/debian_version ]; then
        echo "debian"
    else
        echo "unknown"
    fi
}

OS=$(detect_os)

print_header "Neovim Dependencies Installer"
echo "Detected OS: $OS"

if [ "$OS" == "unknown" ]; then
    print_error "Unsupported OS. This script supports Arch, Debian/Ubuntu, and macOS."
    exit 1
fi

# Package manager commands
install_arch() {
    sudo pacman -S --needed --noconfirm "$@"
}

install_arch_aur() {
    if command -v yay &> /dev/null; then
        yay -S --needed --noconfirm "$@"
    elif command -v paru &> /dev/null; then
        paru -S --needed --noconfirm "$@"
    else
        print_warning "No AUR helper found. Please install $* manually or install yay/paru."
    fi
}

install_debian() {
    sudo apt-get install -y "$@"
}

install_macos() {
    brew install "$@"
}

# Update package manager
print_header "Updating Package Manager"

case $OS in
    arch)
        sudo pacman -Syu --noconfirm
        print_success "Pacman updated"
        ;;
    debian)
        sudo apt-get update && sudo apt-get upgrade -y
        print_success "APT updated"
        ;;
    macos)
        if ! command -v brew &> /dev/null; then
            print_warning "Homebrew not found. Installing..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew update
        print_success "Homebrew updated"
        ;;
esac

# ================================
# Core Dependencies
# ================================
print_header "Installing Core Dependencies"

case $OS in
    arch)
        install_arch neovim git curl wget unzip
        ;;
    debian)
        # Neovim from unstable/backports for newer version
        if ! command -v nvim &> /dev/null; then
            print_warning "Installing Neovim from source or PPA recommended for latest version"
            install_debian neovim
        fi
        install_debian git curl wget unzip
        ;;
    macos)
        install_macos neovim git curl wget
        ;;
esac
print_success "Core dependencies installed"

# ================================
# Search Tools (Telescope deps)
# ================================
print_header "Installing Search Tools (ripgrep, fd)"

case $OS in
    arch)
        install_arch ripgrep fd
        ;;
    debian)
        install_debian ripgrep fd-find
        # Create symlink for fd (Debian names it fdfind)
        if [ ! -L /usr/local/bin/fd ] && command -v fdfind &> /dev/null; then
            sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
        fi
        ;;
    macos)
        install_macos ripgrep fd
        ;;
esac
print_success "Search tools installed"

# ================================
# Programming Languages
# ================================
print_header "Installing Programming Languages"

# Go
echo "Installing Go..."
case $OS in
    arch)
        install_arch go
        ;;
    debian)
        install_debian golang-go
        ;;
    macos)
        install_macos go
        ;;
esac
print_success "Go installed"

# Rust
echo "Installing Rust..."
if ! command -v rustc &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
    print_success "Rust installed via rustup"
else
    print_success "Rust already installed"
fi

# Python
echo "Installing Python..."
case $OS in
    arch)
        install_arch python python-pip python-virtualenv
        ;;
    debian)
        install_debian python3 python3-pip python3-venv
        ;;
    macos)
        install_macos python
        ;;
esac
print_success "Python installed"

# Node.js
echo "Installing Node.js..."
case $OS in
    arch)
        install_arch nodejs npm
        ;;
    debian)
        # Install Node.js via NodeSource for latest LTS
        if ! command -v node &> /dev/null; then
            curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
            install_debian nodejs
        fi
        ;;
    macos)
        install_macos node
        ;;
esac
print_success "Node.js installed"

# ================================
# LaTeX Support (vimtex)
# ================================
print_header "Installing LaTeX Support"

case $OS in
    arch)
        install_arch texlive-basic texlive-latex texlive-latexrecommended texlive-latexextra latexmk zathura zathura-pdf-mupdf
        ;;
    debian)
        install_debian texlive-latex-base texlive-latex-recommended texlive-latex-extra latexmk zathura
        ;;
    macos)
        if ! command -v latexmk &> /dev/null; then
            print_warning "Installing MacTeX (this may take a while)..."
            brew install --cask mactex-no-gui
        fi
        install_macos zathura zathura-pdf-mupdf
        ;;
esac
print_success "LaTeX support installed"

# ================================
# Formatters & Linters
# ================================
print_header "Installing Formatters & Linters"

# Stylua (Lua formatter)
echo "Installing stylua..."
case $OS in
    arch)
        install_arch stylua
        ;;
    debian)
        cargo install stylua
        ;;
    macos)
        install_macos stylua
        ;;
esac
print_success "stylua installed"

# Prettier (JS/TS/HTML/CSS formatter)
echo "Installing prettier..."
sudo npm install -g prettier
print_success "prettier installed"

# Python formatters
echo "Installing Python formatters (black, isort)..."
pip3 install --user black isort
print_success "Python formatters installed"

# Terraform tools
echo "Installing Terraform tools..."
case $OS in
    arch)
        install_arch terraform
        install_arch_aur tflint
        ;;
    debian)
        # Terraform
        if ! command -v terraform &> /dev/null; then
            curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
            echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
            sudo apt-get update
            install_debian terraform
        fi
        # tflint
        curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
        ;;
    macos)
        install_macos terraform tflint
        ;;
esac
print_success "Terraform tools installed"

# ================================
# Debuggers (DAP)
# ================================
print_header "Installing Debuggers"

# Delve (Go debugger)
echo "Installing delve (Go debugger)..."
go install github.com/go-delve/delve/cmd/dlv@latest
print_success "delve installed"

# LLDB (for codelldb/Rust debugging)
echo "Installing LLDB..."
case $OS in
    arch)
        install_arch lldb
        ;;
    debian)
        install_debian lldb
        ;;
    macos)
        # LLDB comes with Xcode command line tools
        if ! command -v lldb &> /dev/null; then
            xcode-select --install 2>/dev/null || true
        fi
        ;;
esac
print_success "LLDB installed"

# ================================
# Additional Tools
# ================================
print_header "Installing Additional Tools"

# Bash language server dependency
case $OS in
    arch)
        install_arch bash-language-server shellcheck
        ;;
    debian)
        sudo npm install -g bash-language-server
        install_debian shellcheck
        ;;
    macos)
        install_macos bash-language-server shellcheck
        ;;
esac
print_success "Shell tools installed"

# Tree-sitter CLI (for parser compilation)
echo "Installing tree-sitter CLI..."
case $OS in
    arch)
        install_arch tree-sitter
        ;;
    debian|macos)
        cargo install tree-sitter-cli
        ;;
esac
print_success "tree-sitter CLI installed"

# ================================
# Optional: Ollama (Local LLM)
# ================================
print_header "Optional: Ollama (Local LLM)"

read -p "Install Ollama for local LLM support? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    curl -fsSL https://ollama.com/install.sh | sh
    print_success "Ollama installed"
else
    print_warning "Skipping Ollama installation"
fi

# ================================
# Setup Go and Rust paths
# ================================
print_header "Setting up PATH"

SHELL_RC=""
if [ -n "$ZSH_VERSION" ] || [ -f "$HOME/.zshrc" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ] || [ -f "$HOME/.bashrc" ]; then
    SHELL_RC="$HOME/.bashrc"
fi

if [ -n "$SHELL_RC" ]; then
    # Go path
    if ! grep -q 'GOPATH' "$SHELL_RC"; then
        echo 'export GOPATH="$HOME/go"' >> "$SHELL_RC"
        echo 'export PATH="$PATH:$GOPATH/bin"' >> "$SHELL_RC"
    fi

    # Rust/Cargo path
    if ! grep -q '.cargo/bin' "$SHELL_RC"; then
        echo 'export PATH="$PATH:$HOME/.cargo/bin"' >> "$SHELL_RC"
    fi

    # Python user packages
    if ! grep -q '.local/bin' "$SHELL_RC"; then
        echo 'export PATH="$PATH:$HOME/.local/bin"' >> "$SHELL_RC"
    fi

    print_success "PATH variables added to $SHELL_RC"
fi

# ================================
# Mason will handle LSP servers
# ================================
print_header "LSP Servers"

echo "The following LSP servers will be auto-installed by Mason when you open Neovim:"
echo "  - bashls (Bash)"
echo "  - rust_analyzer (Rust)"
echo "  - lua_ls (Lua)"
echo "  - marksman (Markdown)"
echo "  - pyright (Python)"
echo "  - terraformls (Terraform)"
echo "  - tflint (Terraform)"
echo "  - jsonls (JSON)"
echo "  - gopls (Go)"
echo "  - html (HTML)"
echo "  - cssls (CSS)"
echo "  - texlab (LaTeX)"
echo "  - ts_ls (TypeScript/JavaScript)"
echo "  - yamlls (YAML)"
echo "  - tailwindcss-language-server (Tailwind CSS)"

print_warning "Run :Mason in Neovim to manage LSP servers"

# ================================
# Summary
# ================================
print_header "Installation Complete!"

echo "Installed components:"
echo "  ✓ Core: neovim, git, curl, wget"
echo "  ✓ Search: ripgrep, fd"
echo "  ✓ Languages: Go, Rust, Python, Node.js"
echo "  ✓ LaTeX: texlive, latexmk, zathura"
echo "  ✓ Formatters: stylua, prettier, black, isort"
echo "  ✓ Terraform: terraform, tflint"
echo "  ✓ Debuggers: delve, lldb"
echo "  ✓ Shell: bash-language-server, shellcheck"
echo "  ✓ Tree-sitter CLI"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal or run: source $SHELL_RC"
echo "  2. Open Neovim - Mason will auto-install LSP servers"
echo "  3. Run :checkhealth to verify everything works"
echo ""

if [ "$OS" == "macos" ]; then
    print_warning "macOS users: You may need to restart your terminal for PATH changes"
fi

print_warning "GitHub Copilot: Run :Copilot setup in Neovim to authenticate"
print_warning "Wakatime: Run :WakaTimeApiKey in Neovim to set your API key"
