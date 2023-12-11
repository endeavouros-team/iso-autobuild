#!/bin/sh
# building calamares git packages:
pacman -Syy
#pacman -S --noconfirm --needed cmake extra-cmake-modules kpmcore boost python-jsonschema python-pyaml python-unidecode qt5-svg qt5-webengine yaml-cpp networkmanager upower kconfig kservice squashfs-tools rsync qt5-xmlpatterns doxygen dmidecode gptfdisk hwinfo kparts solid qt5-tools libpwquality ckbcomp qt5-quickcontrols2
useradd -m -G wheel -s /bin/bash build
cd /home/build
mkdir -p /home/build/packages
chown -R build:build /home/build/packages
su build
git clone https://github.com/endeavouros-team/PKGBUILDS
cd /home/build/PKGBUILDS/calamares-git
makepkg -f -s
cp *.pkg.tar.zst /home/build/packages/
exit
