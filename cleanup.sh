#!/bin/sh
echo "Cleaning up ISO build structure..."
rm -rf "EndeavourOS-ISO/work"
rm -rf EndeavourOS-ISO/airootfs/etc/pacman.d/
echo "Cleaning up large temporary directories..."
rm -rf node_modules dist build logs tmp .cache
