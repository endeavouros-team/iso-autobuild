#!/bin/sh
# building calamares git packages:
echo "%wheel         ALL = (ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
pacman -Syy
pacman -S --noconfirm --needed plasma-framework5 plasma5support git cmake extra-cmake-modules kpmcore boost python-jsonschema python-pyaml python-unidecode gawk qt5-svg qt5-webengine yaml-cpp networkmanager upower kcoreaddons5 kconfig5 ki18n5 kservice5 kwidgetsaddons5 kpmcore squashfs-tools rsync cryptsetup qt5-xmlpatterns doxygen dmidecode gptfdisk hwinfo kparts5 polkit-qt5 python solid5 qt5-tools boost-libs libpwquality ckbcomp qt5-quickcontrols2
useradd -m -G wheel -s /bin/bash build
cd /home/build
mkdir -p /home/build/packages
chown -R build:build /home/build/packages
sudo -u  build git clone https://github.com/endeavouros-team/PKGBUILDS
cd /home/build/PKGBUILDS/calamares-git
sudo -u  build makepkg -f
cp *.pkg.tar.zst /home/build/packages/
