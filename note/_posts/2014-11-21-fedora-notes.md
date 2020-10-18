---
title: Fedora Notes
---

```shell
# ^_^
sudo su -

# Configure dnf
cat <<EOF >> /etc/dnf/dnf.conf
fastestmirror=True
EOF

dnf update

dnf install http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

dnf install gnome-tweak-tool gnome-shell-extension-window-list gnome-shell-extension-apps-menu gnome-terminal-nautilus vim ruby nodejs

dnf group install "Development Tools" "C Development Tools and Libraries"

# Install chrome
# dnf install https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm

# Disable mouse acceleration
# dnf remove xorg-x11-drv-libinput
# cat <<EOF > /etc/X11/xorg.conf.d/50-no-mouse-acceleration.conf
# Section "InputClass"
#     Identifier "My Mouse"
#     MatchIsPointer "yes"
#     Option "AccelerationProfile" "-1"
#     Option "AccelerationScheme" "none"
# EndSection
# EOF

# Remove unnecessary softwares
# dnf remove orca gnome-software gnome-weather gnome-maps gnome-clocks abrt*

# Handle lid switch
# vim /etc/systemd/logind.conf

# Configure grub
# In Hyper-V:
# append "video=hyperv_fb:1920x1080 elevator=noop" to GRUB_CMDLINE_LINUX
# To hide the boot menu, set
# GRUB_TIMEOUT=0
# GRUB_HIDDEN_TIMEOUT=1
# GRUB_HIDDEN_TIMEOUT_QUIET=true
vim /etc/default/grub
grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg

# Default to cli
# systemctl set-default multi-user.target

# Disable SELinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

# Disable firewall
# systemctl disable firewalld

# Start an OpenSSH server
# service sshd start

# Change firefox UI language
# https://addons.mozilla.org/firefox/language-tools/
# about:config intl.locale.requested (zh-CN)

# Shadowsocks
# dnf copr enable librehat/shadowsocks
# dnf install shadowsocks-libev

# Sublime Text
# rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
# dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
# dnf install sublime-text

# NAT static IP address
# vim /etc/sysconfig/network-scripts/ifcfg-eth0
# BOOTPROTO=none
# IPADDR=192.168.200.22
# PREFIX=24
# GATEWAY=192.168.200.1
# DNS1=a.b.c.d
# DNS2=a.b.c.d
```
