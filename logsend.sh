#!/bin/bash

# ISO tester log-script:
# This script collects various system information after asking the user.
# It is modular and easy to extend with new questions.
# The final report can be saved locally or uploaded via filebin.

timestamp=$(date +"%Y%m%d-%H%M%S")
outfile="/tmp/sysreport-$timestamp.txt"

echo "=== System Information Collector ==="
echo "A report will be created at: $outfile"
echo

# Function for yes/no questions
ask() {
    read -rp "$1 (y/n): " ans
    [[ "$ans" == "y" || "$ans" == "Y" ]]
}

# Function to append a section header
add_header() {
    echo -e "\n\n===== $1 =====" >> "$outfile"
}

# NVIDIA section
if ask "Collect NVIDIA information?"; then
    add_header "NVIDIA: inxi -Gaz"
    inxi -Gaz >> "$outfile" 2>&1

    add_header "NVIDIA: pacman -Qs nvidia"
    pacman -Qs nvidia >> "$outfile" 2>&1
fi

# Intel section
if ask "Collect Intel GPU information?"; then
    add_header "Intel: inxi -Gaz"
    inxi -Gaz >> "$outfile" 2>&1

    add_header "Intel: pacman -Qs intel"
    pacman -Qs intel >> "$outfile" 2>&1
fi

# Broadcom section
if ask "Collect Broadcom WiFi information?"; then
    add_header "Broadcom: inxi -Naz"
    inxi -Naz >> "$outfile" 2>&1

    add_header "Broadcom: pacman -Qs broadcom"
    pacman -Qs broadcom >> "$outfile" 2>&1
fi

# Installer log
if ask "Collect EndeavourOS installer log? (requires sudo)"; then
    add_header "Installer Log: /var/log/endeavour-install.log"
    sudo cat /var/log/endeavour-install.log >> "$outfile" 2>&1
fi

# Partition info
if ask "Collect partition information? (requires sudo)"; then
    add_header "Partition Info: fdisk -l"
    sudo fdisk -l >> "$outfile" 2>&1

    add_header "Partition Info: /etc/fstab"
    cat /etc/fstab >> "$outfile" 2>&1
fi

# Boot log
if ask "Collect boot log (journalctl -b -0)?"; then
    add_header "Boot Log: journalctl -b -0"
    journalctl -b -0 >> "$outfile" 2>&1
fi

# Installed packages
if ask "Collect installed packages list?"; then
    add_header "Installed Packages: pacman -Qq"
    pacman -Qq >> "$outfile" 2>&1
fi


echo
echo "=== Report creation done ==="
echo "File saved at: $outfile"
echo

# Upload or local?
read -rp "Upload to filebin (curl) instead of local file? (y/n): " upload

if [[ "$upload" =~ ^[Yy]$ ]]; then
    echo "Uploading..."
    # example filebin (you can replace with your preferred service)
    result=$(curl -s -F "file=@$outfile" https://filebin.net)
    echo "Upload result:"
    echo "$result"
else
    echo "Report stored locally:"
    echo "$outfile"
fi

echo "Done."
