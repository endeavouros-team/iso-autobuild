#!/bin/sh

# setting up EndeavourOS repo:
pacman -Sy --noconfirm --needed archlinux-keyring
cp  "pacman.conf" "/etc/pacman.conf"
cp  "endeavouros-mirrorlist" "/etc/pacman.d/endeavouros-mirrorlist"
pacman-key --init
pacman -Syy --noconfirm endeavouros-keyring 
pacman -Syy --noconfirm endeavouros-mirrorlist
