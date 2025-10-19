#!/bin/bash

echo "Edit /etc/pacman.conf"
sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 50\nILoveCandy/' /etc/pacman.conf

clear
echo "Wait for update mirrors..."
pacman -Syu --needed --noconfirm reflector
./update-mirrors.sh

clear
echo "Wait for the necessary packages to be installed..."
pacman -Syu --noconfirm
pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
pacman-key --lsign-key 3056513887B78AEB
pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
echo '[chaotic-aur]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/chaotic-mirrorlist' >> /etc/pacman.conf
pacman -Syu --needed --noconfirm rsync paru

clear
echo "Copies configs"
rsync -rltu root/ / # r - recursive, l - simlinks as simlinks, t - time modification, u - update
rsync -rltu .config/ /root/.config/

clear
echo "Wait until all remaining packages are installed..."
pacman -Syu --needed --noconfirm - < packages
