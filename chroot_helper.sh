#!/bin/bash

ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
hwclock --systohc

echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
locale-gen

while true
do
    read -p "Enter the hostname for this machine: " NEW_HOSTNAME
    echo

    echo "The new hostname will be: ${NEW_HOSTNAME}"
    read -p "is this correct? [y/N] " CORRECT

    case $CORRECT in
        [yY])
            break ;;
        *)
            echo "Starting over"
            ;;
    esac
done
CORRECT=""

echo $NEW_HOSTNAME > /etc/hostname
echo '127.0.0.1 localhost
::1\t localhost
127.0.1.1\t $NEW_HOSTNAME' > /etc/hosts

echo "Installing new packages"

pacman -S archlinux-keyring
pacman -S grub networkmanager base-devel git zsh sudo chezmoi

sudo systemctl enable NetworkManager.service

while true
do
    read -p "Enter the new user name: " NEW_NAME
    echo

    echo "The new user will be: ${NEW_NAME}"
    read -p "is this correct? [y/N] " CORRECT

    case $CORRECT in
        [yY])
            break ;;
        *)
            echo "Starting over"
            ;;
    esac
done
CORRECT=""

useradd -m -G wheel,input,video,audio,storage,disk,kvm  -s /bin/zsh $NEW_NAME

while true
do
    echo 'SUDO configuration, please edit the SUDOER file'
    EDITOR=nvim visudo

    read -p "Is everything correct? [y/N] " CORRECT

    case $CORRECT in
        [yY])
            break ;;
        *)
            echo 'Starting over'
            ;;
    esac
done
CORRECT=""

echo "Finished !"
echo 'Before restarting set the password for root and $NEW_NAME with passwd
and setup grub'
