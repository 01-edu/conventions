#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

# Check for root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root or with sudo."
    echo "Please run with sudo: sudo $0"
    exit 1
fi

# Detect OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if [[ ! -f /etc/os-release || "$(grep -i 'ubuntu' /etc/os-release)" == "" ]]; then
    echo "This script is intended for Ubuntu systems only."
    echo "Detected OS: $(grep '^PRETTY_NAME=' /etc/os-release | cut -d= -f2 | tr -d '"')"
    echo "Please run this script on an Ubuntu system."
    echo "Exiting..."
    exit 1
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then

    echo "This script is intended for Ubuntu systems only."
    echo "Detected OS: macOS"
    exit 1
else
    echo "Unsupported OS: $OSTYPE"
    exit 1
fi

# Setup hostname   
function setup_hostname() {
    local current_hostname
    current_hostname=$(hostname)
    echo "Current hostname: $current_hostname"
    read -rp "Do you want to change the hostname? (y/N): " change
    if [[ "$change" =~ ^[Yy]$ ]]; then
        read -rp "Enter new hostname: " new_hostname
        sudo hostnamectl set-hostname "$new_hostname"
        sudo sed -i "s/$current_hostname/$new_hostname/g" /etc/hosts
        echo "Hostname changed to $new_hostname"
    fi
}

# System update & upgrade
function update_and_upgrade() {
    sudo apt update && sudo apt upgrade -y && sudo apt dist-upgrade -y && sudo apt autoremove -y && sudo apt autoclean
}

# Setup packages
function setup_packages() {
    # Core tools
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common git gnupg2 jq wget htop whois sqlite3 unzip zip lz4 file brotli tree mc screen iotop build-essential net-tools libnss3-tools
    
    # Docker
    if ! command -v docker >/dev/null; then
        curl -fsSL https://get.docker.com | sh
    else
        echo "Docker is already installed."
    fi

    # Node.js (v22.x)
    if ! command -v node >/dev/null; then
        curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
        sudo apt install -y nodejs
    else
        echo "Node.js is already installed."
    fi

    # Install Golang
    if ! command -v go >/dev/null; then
        echo "Installing Go..."
        if [[ -f /tmp/go-installer.sh ]]; then
            rm -f /tmp/go-installer.sh
        fi
        curl -sL https://git.io/go-installer.sh -o /tmp/go-installer.sh
        chmod +x /tmp/go-installer.sh
        


        # Install as invoking user
        USER_HOME=$(eval echo ~"${SUDO_USER}")
        sudo -u "${SUDO_USER}" HOME="${USER_HOME}" bash /tmp/go-installer.sh

        # Uncomment the next line if you want to install as root
        #HOME="/root" bash /tmp/go-installer.sh
    else
        echo "Go is already installed."
    fi

    # Install mkcert
    if ! command -v mkcert >/dev/null; then
        sudo apt install -y mkcert
        mkcert -install
    else
        echo "mkcert is already installed."
    fi

    # Install hasura cli
    if ! command -v hasura >/dev/null; then
        curl -L https://github.com/hasura/graphql-engine/raw/stable/cli/get.sh | bash
    else
        echo "hasura is already installed."
    fi

    # Install aws cli v2
    if ! command -v aws >/dev/null; then
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
        unzip awscliv2.zip
        sudo ./aws/install
        rm -rf awscliv2.zip aws
    else
        echo "AWS Cli is already installed."
    fi
}

# Setup SSH keys
function setup_ssh_keys() {
    mkdir -p ~/.ssh
    if [[ -f ~/.ssh/id_ed25519 && -f ~/.ssh/id_ed25519.pub ]]; then
        echo "SSH keypair already exists."
        read -rp "Do you want to (b)ackup, (k)eep, or (g)enerate new? [b/k/g]: " key_choice
        case "$key_choice" in
        b | B)
            backup_dir=~/.ssh/backup_$(date +%Y%m%d_%H%M%S)
            mkdir -p "$backup_dir"
            cp ~/.ssh/id_ed25519* "$backup_dir/"
            echo "Backed up to $backup_dir"
            ;;
        k | K)
            echo "Keeping existing key."
            ;;
        g | G)
            mv ~/.ssh/id_ed25519* "$HOME/.ssh/backup_$(date +%Y%m%d_%H%M%S)/"
            echo "Enter user email for the SSH key (default: ${USER}@$(hostname)):"
            read -rp "Email (your 01talent email): " user_email
            email="${user_email:-${USER}@$(hostname)}"
            echo "Generating new SSH keypair with email: $email"
            ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N "" -C "$email"
            ;;

        esac

    else
        echo "Enter user email for the SSH key (default: ${USER}@$(hostname)):"
        read -rp "Email (your 01talent email): " user_email
        email="${user_email:-${USER}@$(hostname)}"
        echo "Generating new SSH keypair with email: $email"
        ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N "" -C "$email"
    fi
}

# Setup Git credentials and signing
function setup_git_credentials() {
    echo "Enter your name for Git configuration (default: $USER):"
    read -rp "Name: " user_name
    git config --global user.name "${user_name:-$USER}"
    echo "Enter your email for Git configuration (default: ${USER}@$(hostname)):"
    read -rp "Email: " user_email
    user_email="${user_email:-${USER}@$(hostname)}"
    git config --global user.email "$user_email"
    git config --global user.signingkey ~/.ssh/id_ed25519
    git config --global commit.gpgsign true
    echo "Git configured to use SSH and sign commits by default."
}

# Show SSH Keys
function show_ssh_keys() {
    echo "Your SSH public key is:"
    echo "   $(cat ~/.ssh/id_ed25519.pub)"
    echo "   Copy this key to your clipboard."
    echo "2. Go to GitHub → Settings → SSH and GPG keys → New SSH key"
    echo "3. Paste the key and save."
    echo "4. Test with: ssh -T git@github.com"
}

# Setup DNS
function setup_dns() {
    echo "Choose DNS provider:"
    echo "1) Cloudflare (1.1.1.1, 1.0.0.1)"
    echo "2) AdGuard (94.140.14.14, 94.140.15.15)"
    echo "3) Google (8.8.8.8, 8.8.4.4)"
    echo "4) Quad9 (9.9.9.9, 149.112.112.112)"
    echo "5) Leave unchanged (current DNS will remain)"
    read -rp "Selection [1-5]: " dns_choice
    case "$dns_choice" in
        1) dns1="1.1.1.1"; dns2="1.0.0.1" ;;
        2) dns1="94.140.14.14"; dns2="94.140.15.15" ;;
        3) dns1="8.8.8.8"; dns2="8.8.4.4" ;;
        4) dns1="9.9.9.9"; dns2="149.112.112.112" ;;
        5) echo "Leaving DNS unchanged."; return ;;
        *) echo "Invalid choice"; return ;;
    esac

    # Backup
    sudo cp /etc/systemd/resolved.conf /etc/systemd/resolved.conf.bak

    # Update the DNS
    sudo sed -i '/^DNS=/d' /etc/systemd/resolved.conf
    sudo sed -i '/^FallbackDNS=/d' /etc/systemd/resolved.conf
    echo -e "[Resolve]\nDNS=${dns1} ${dns2}\nFallbackDNS=${dns2} ${dns1}" | sudo tee /etc/systemd/resolved.conf > /dev/null

    sudo systemctl restart systemd-resolved

    echo "DNS has been updated to $dns1 (primary), $dns2 (fallback) in /etc/systemd/resolved.conf"
}

# Setup 01 Edu registry login
function setup_01edu_registry_login() {
    echo "Logging into 01 Edu Docker Registry..."
    read -rp "Enter the docker registry url: " registry_url
    docker login "$registry_url" && echo "Logged into 01 Edu Docker Registry successfully."
}

function check_all_configs() {
    echo "Checking all required packages..."
    # Check core packages
    local pkgs=(apt-transport-https ca-certificates curl software-properties-common git gnupg2 jq wget htop whois sqlite3 unzip zip lz4 file brotli tree mc screen iotop build-essential net-tools libnss3-tools mkcert nodejs)
    local missing=0
    for pkg in "${pkgs[@]}"; do
        if ! dpkg -s "$pkg" &> /dev/null; then
            echo "  ✘ $pkg (missing)"
            missing=1
        else
            echo "  ✔ $pkg"
        fi
    done

    # Check custom packages
    for cmd in docker go hasura aws; do
        if ! command -v "$cmd" &>/dev/null; then
            echo "  ✘ $cmd (cli missing)"
            missing=1
        else
            echo "  ✔ $cmd"
        fi
    done

    if [[ $missing -eq 0 ]]; then
        echo "✅ All packages and core tools installed."
        return 0
    else
        echo "❗ Some packages/core tools are missing."
        return 1
    fi
}

# Configure everything
function config_everything() {
    update_and_upgrade
    setup_hostname
    setup_dns
    setup_packages
    setup_ssh_keys
    setup_git_credentials
    show_ssh_keys
    setup_01edu_registry_login
    echo "✅ Developer environment setup complete!"
}

# Configure interactively
function config_interactive() {
    local opts=(
        "System update and upgrade"
        "Setup hostname"
        "Setup DNS"
        "Setup packages"
        "Setup SSH keys"
        "Setup Git credentials"
        "Show SSH keys"
        "Docker Registry login"
        "Exit"
    )
    PS3="Select an option to run (1-${#opts[@]}): "
    while true; do
        echo
        for i in "${!opts[@]}"; do
            printf "%2d) %s\n" $((i+1)) "${opts[i]}"
        done
        read -rp "$PS3" REPLY
        case "$REPLY" in
            1) update_and_upgrade ;;
            2) setup_hostname ;;
            3) setup_dns ;;
            4) setup_packages ;;
            5) setup_ssh_keys ;;
            6) setup_git_credentials ;;
            7) show_ssh_keys ;;
            8) setup_01edu_registry_login ;;
            9) echo "Exiting..."; break ;;
            *) echo "Invalid option ($REPLY)";;
        esac
    done
}

if [[ $# -gt 0 ]]; then
    case "$1" in
        --check)   check_all_configs ;;
        --config)  config_everything ;;
        --choose)  config_interactive ;;
        --help | -h)
            echo "Usage: $0 [--check | --config | --choose]"
            echo "  --check   Check all required packages and tools"
            echo "  --config  Configure everything in one go"
            echo "  --choose  Choose specific configurations interactively"
            exit 0 ;;
        *)
            echo "Invalid option: $1"
            echo "Use --help for usage information."
            exit 1 ;;
    esac
    exit 0
fi

# default to check
check_all_configs