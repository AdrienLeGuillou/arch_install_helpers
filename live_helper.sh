#!/bin/bash

echo 'This script assumes the partions are already mounted on /mnt
and the system is connected to the Internet'
read -p "Are you ready to continue? [y/N] " CONTINUE
case $CONTINUE in
    [yY])
        echo
        ;;
    *)
        echo "Quitting"
        exit 1
        ;;
esac

while true
do
    read -p "Enter the swapfile size in Mb: " SWAPSIZE
    echo

    echo "this will create a swapfile of size ${SWAPSIZE}Mb"
    read -p "is this correct? [y/N] " CORRECT

    case $CORRECT in
        [yY])
            break ;;
        *)
            echo "Starting over"
            ;;
    esac
done

timedatectl set-ntp true
timedatectl status

dd if=/dev/zero of=/mnt/swapfile bs=1M count=$SWAPSIZE status=progress
chmod 600 /mnt/swapfile
mkswap /mnt/swapfile
swapon /mnt/swapfile

pacstrap /mnt base linux linux-firmware neovim

genfstab -U /mnt >> /mnt/etc/fstab

echo 'Pre chroot phase finished. Run `arch-chroot /mnt` and run the next script'
