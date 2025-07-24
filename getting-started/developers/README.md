# 01 Edu Developer Environment Setup

## Overview

This script partially automates the setup of your development environment on **Ubuntu** systems, tailored specifically for the 01 Edu team.

## Script Features

- **Hostname Setup**  
  Interactive option to view and change the system hostname.

- **System Update & Upgrade**  
  Updates package lists and upgrades all system packages.

- **Packages Installation**  
  Installs core utilities and development dependencies:

  - Core tools: `git`, `curl`, `htop`, `jq`, `build-essential`, and more
  - Docker
  - Node.js v22.x
  - Golang
  - mkcert (for local TLS certificates)
  - Hasura CLI
  - AWS CLI v2

- **SSH Key Management**  
  Detects existing SSH keys and offers options to backup, keep, or generate new ed25519 SSH keys.

- **Git Configuration**  
  Prompts for Git user name and email, sets global config, and enables commit signing.

- **Display SSH Public Key**  
  Shows your public SSH key with instructions to add it to GitHub.

- **DNS Configuration**  
  Choose among Cloudflare, AdGuard, Google, Quad9 DNS providers, or leave unchanged.

- **01 Edu Docker Registry Login**  
  Prompts for Docker registry URL to log in (Please contact your team-lead for credentials).

- **Verification Mode**  
  Checks presence of all required packages and tools, identifying any missing components.

## Usage

Run the script with **sudo** privileges for full setup:

```
sudo ./config-ubuntu.sh --config
```

Use interactive mode to choose individual setup steps:

```
sudo ./config-ubuntu.sh --choose
```

Verify installed tools and packages without changes:

```
./config-ubuntu.sh --check
```

Display help:

```
./config-ubuntu.sh --help
```

## Intended Audience

- New team members onboarding onto Ubuntu development environments
- Existing contributors who wish to verify or refresh their developer setup
