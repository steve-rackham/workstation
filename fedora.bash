#!/bin/bash
"SETUP FEDORA WORKSTATION: ##############"
"ADD RPM REPO: ##########################"
"Adding Free RPM..."
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

 "Adding Non-Free RPM..."
sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

"ADD BROADCOM WIFI: #####################"
sudo dnf install broadcom-wl

# PC: #################################
sudo hostnamectl set-hostname '$USER-PC'

# SSH: ################################
"# SSH Configuration: #################" 
systemctl enable sshd
systemctl start sshd

# GNOME: ##############################
sudo dnf install gnome-tweaks -y

# KDE: ################################
sudo dnf install kvantum

# TERMINAL: ###########################
curl -fsSL https://starship.rs/install.sh | bash
echo 'eval "$(starship init zsh)"' >> .zshrc

# GIT: ################################
ssh-keygen -t ed25519 -C "steve@siliconwolf.net"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
git config --global user.name "Steve Rackham"
git config --global user.email "steve@siliconwolf.net"

# CALDAV: 
# https://dav.mailbox.org/caldav/Y2FsOi8vMC8zMQ/
# https://p34-caldav.icloud.com/16051280414/calendars/home/
# https://dav.mailbox.org/carddav/32
# https://dav.mailbox.org/caldav/MzM/

flatpak install com.vscodium.codium io.freetubeapp.FreeTube tv.plex.PlexDesktop
dnf install \
    evolution \
    ansible \
    gnome-shell-extension-user-theme \
    hugo \
    gnome-extensions-app \
    gnome-shell-extension-dash-to-dock \
    gnome-tweaks \
    steam \
    lutris \
    starship \
    fira-code-fonts \
    broadcom-wl \
    hwinfo
