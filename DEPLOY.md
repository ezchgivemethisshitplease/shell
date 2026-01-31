# Server Deployment Guide

Quick reference for deploying dotfiles to remote servers.

## 🚀 Quick Deploy

### Single Server

```bash
# SSH to server
ssh user@server

# Install (force mode - overwrites existing configs)
curl -fsSL https://raw.githubusercontent.com/yourusername/dotfiles/main/install.sh | bash -s -- --force

# Or clone and run
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh --force

# Apply changes
exec zsh
```

### Multiple Servers (Loop)

Save this as `deploy.sh`:

```bash
#!/bin/bash

# List of servers
SERVERS=(
    "user@server1.example.com"
    "user@server2.example.com"
    "user@server3.example.com"
)

# Deploy to all servers
for server in "${SERVERS[@]}"; do
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Deploying to: $server"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    ssh "$server" bash << 'EOF'
        # Clone or update dotfiles
        if [ -d ~/dotfiles ]; then
            cd ~/dotfiles && git pull
        else
            git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
        fi
        
        # Run installation with force mode
        cd ~/dotfiles
        ./install.sh --force
        
        echo "✓ Deployment complete on $(hostname)"
EOF
    
    echo ""
done

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✓ All deployments complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
```

Run:
```bash
chmod +x deploy.sh
./deploy.sh
```

### SSH Config Integration

If you have SSH hosts in `~/.ssh/config`:

```bash
#!/bin/bash

# Get all SSH hosts from config
SERVERS=$(grep "^Host " ~/.ssh/config | grep -v "\*" | awk '{print $2}')

for server in $SERVERS; do
    echo "Deploying to: $server"
    ssh "$server" 'git clone https://github.com/yourusername/dotfiles.git ~/dotfiles 2>/dev/null || (cd ~/dotfiles && git pull); cd ~/dotfiles && ./install.sh --force'
done
```

## 📋 Deployment Checklist

Before deploying to production servers:

1. **Test locally** - ensure configs work on your machine
2. **Commit changes** - `git add -A && git commit -m "Update configs"`
3. **Push to remote** - `git push`
4. **Deploy to test server first** - verify nothing breaks
5. **Deploy to production** - use `--force` mode

## 🔧 Update Existing Deployments

### Update configs on all servers

```bash
#!/bin/bash

SERVERS=("server1" "server2" "server3")

for server in "${SERVERS[@]}"; do
    echo "Updating $server..."
    ssh "$server" 'cd ~/dotfiles && git pull && source ~/.zshrc'
done
```

### Reinstall everything (nuclear option)

```bash
ssh server 'rm -rf ~/dotfiles ~/.oh-my-zsh ~/.tmux && curl -fsSL https://raw.githubusercontent.com/yourusername/dotfiles/main/install.sh | bash -s -- --force && exec zsh'
```

## 🛡️ Safety Features

### Force mode vs Standard mode

**Standard mode** (default):
- Backs up existing configs to `~/.dotfiles_backup_TIMESTAMP`
- Asks for confirmation before proceeding
- Safe for first-time installations

**Force mode** (`--force` or `-f`):
- Overwrites everything without backup
- No confirmation prompts
- Ideal for:
  - Server automation
  - Re-deployments
  - CI/CD pipelines
  - Known-good state restoration

### Testing before deployment

```bash
# Test on a disposable container
docker run -it ubuntu:22.04 bash

# Inside container
apt update && apt install -y git curl sudo
curl -fsSL https://raw.githubusercontent.com/yourusername/dotfiles/main/install.sh | bash -s -- --force
```

## 📊 Installation Time

**Debian/Ubuntu servers:**
- Standard mode: ~3-5 minutes
- Force mode: ~2-3 minutes
- Network dependent (downloading pre-built binaries)

**What takes time:**
- Package updates (`apt update`)
- Downloading binaries from GitHub
- Installing Oh-My-Zsh + plugins

## 🔍 Verification

After deployment, verify everything works:

```bash
# Check shell
echo $SHELL  # Should show /bin/zsh or /usr/bin/zsh

# Check tools
which eza bat delta rg btop zoxide fzf

# Check ZSH plugins
ls ~/.oh-my-zsh/custom/plugins/

# Check tmux plugins
ls ~/.tmux/plugins/

# Test commands
l      # Should use eza
ll     # Should show detailed list
gst    # Should work (git status)
```

## 🐛 Troubleshooting Deployments

### Git clone fails (private repo)

**Option 1: SSH key**
```bash
# Add SSH key to server
ssh-copy-id user@server

# Clone with SSH
git clone git@github.com:yourusername/dotfiles.git ~/dotfiles
```

**Option 2: Personal Access Token**
```bash
git clone https://TOKEN@github.com/yourusername/dotfiles.git ~/dotfiles
```

### Permission denied (chsh)

Some servers don't allow users to change shell:

```bash
# Workaround: add to ~/.bashrc
echo 'exec zsh' >> ~/.bashrc
```

### Tmux plugins not installing

After deployment:
```bash
# SSH to server
ssh server

# Open tmux
tmux

# Install plugins manually
# Press: Ctrl+A then I (capital i)
```

## 📝 Example Workflows

### Daily workflow

1. Make changes locally
2. Test in your terminal
3. Commit: `cd ~/dotfiles && git add -A && git commit -m "Update X"`
4. Push: `git push`
5. Update servers: `./deploy.sh`

### Emergency rollback

```bash
# On server
cd ~/dotfiles
git log --oneline  # Find good commit hash
git reset --hard COMMIT_HASH
./install.sh --force
source ~/.zshrc
```

### Keep servers in sync

Add to crontab on each server:
```bash
# Auto-update dotfiles daily at 3 AM
0 3 * * * cd ~/dotfiles && git pull && source ~/.zshrc
```

## 🎓 Advanced: Ansible Playbook

For large-scale deployments:

```yaml
# deploy-dotfiles.yml
---
- name: Deploy dotfiles to servers
  hosts: all
  tasks:
    - name: Clone or update dotfiles
      git:
        repo: 'https://github.com/yourusername/dotfiles.git'
        dest: '~/dotfiles'
        update: yes
    
    - name: Run installation script
      shell: |
        cd ~/dotfiles
        ./install.sh --force
      args:
        executable: /bin/bash
    
    - name: Change default shell
      user:
        name: "{{ ansible_user }}"
        shell: /usr/bin/zsh
      become: yes
```

Run:
```bash
ansible-playbook -i inventory.ini deploy-dotfiles.yml
```

---

**Pro tip:** Always test on a single server first, then roll out to production!
