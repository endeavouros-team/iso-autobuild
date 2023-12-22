#!/bin/sh

# setting up EndeavourOS repo:
pacman -Sy --noconfirm --needed archlinux-keyring
cp  "pacman.conf" "/etc/pacman.conf"
cp  "endeavouros-mirrorlist" "/etc/pacman.d/endeavouros-mirrorlist"
pacman-key --init && pacman-key --recv-key 003DB8B0CB23504F --keyserver keyserver.ubuntu.com && pacman-key --lsign-key 003DB8B0CB23504F
pacman-key --init
pacman -Sy --noconfirm endeavouros-keyring 
pacman -S --noconfirm endeavouros-mirrorlist
pacman -S --noconfirm reflector 
reflector --age 2 --number 23 --country DE,US,NL,PL --save /etc/pacman.d/mirrorlist
