#!/bin/bash

# Script: logsend.sh a ISO tester log tool
# Description: Collects various system information and logs it to a file,
#              then sends it using eos-sendlog.
# Author: joekamprad
# Date: July 27, 2025

# --- Configuration ---
LOG_FILE="/tmp/testerlogs.log"
HOME_DIR="$HOME"

# --- Functions ---

# Function to log output with a section header
log_section() {
    local header="$1"
    local command="${*:2}" # All arguments from the second onwards
    echo "---------------------------------------------------" | tee -a "$LOG_FILE"
    echo "--- $header ---" | tee -a "$LOG_FILE"
    echo "---------------------------------------------------" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE" # Add a newline for spacing

    # Execute the command and direct its output to the log file
    # and to stderr (so it doesn't clutter stdout if the script is piped)
    if eval "$command" >> "$LOG_FILE" 2>&1; then
        echo "Successfully collected $header." >&2
    else
        echo "WARNING: Failed to collect $header." >&2
    fi
    echo "" | tee -a "$LOG_FILE" # Add a newline after the section
}

# Function to check if a file exists before trying to cat it
log_file_if_exists() {
    local header="$1"
    local filepath="$2"
    echo "---------------------------------------------------" | tee -a "$LOG_FILE"
    echo "--- $header ---" | tee -a "$LOG_FILE"
    echo "---------------------------------------------------" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE" # Add a newline for spacing

    if [[ -f "$filepath" ]]; then
        cat "$filepath" >> "$LOG_FILE" 2>&1
        echo "Successfully included content from $filepath." >&2
    else
        echo "WARNING: Log file '$filepath' not found." >> "$LOG_FILE" 2>&1
        echo "WARNING: Log file '$filepath' not found." >&2
    fi
    echo "" | tee -a "$LOG_FILE" # Add a newline after the section
}

# --- Script Start ---

echo "Starting system information collection..."
echo "Output will be logged to $LOG_FILE"
echo "You will see progress messages here."
echo ""

# Clear previous log file content or create a new one
> "$LOG_FILE" || { echo "ERROR: Could not create/clear log file $LOG_FILE. Aborting." >&2; exit 1; }
echo "Log file initialized at $(date)" >> "$LOG_FILE"

# 1. Gather inxi general info
log_section "System Information (inxi -Gaz)" "inxi -Gaz"

# 2. Gather NVIDIA package info
log_section "NVIDIA Packages (pacman -Qs nvidia)" "pacman -Qs nvidia"

# 3. Gather Intel package info (using xf86-video as a common indicator)
log_section "Intel Video Packages (pacman -Qs xf86-video)" "pacman -Qs xf86-video"

# 4. Gather Broadcom check log
log_file_if_exists "Broadcom WL Driver Check Log" "$HOME_DIR/broadcom-wl-check.log"

# 5. Gather Broadcom enable log
log_file_if_exists "Broadcom WL WiFi Activation Log" "$HOME_DIR/broadcom-wl-wifi-activation.log"

# 6. Gather lspci detailed info
log_section "PCI Devices (lspci -vnn)" "lspci -vnn"

# 7. Gather installer log
log_file_if_exists "EndeavourOS install log" "$HOME/endeavour-install.log"

echo "Collection complete. Copying log to $HOME_DIR and sending..."

# Copy the log file to HOME directory
if cp "$LOG_FILE" "$HOME_DIR/"; then
    echo "Log file copied to $HOME_DIR/$(basename "$LOG_FILE")" >&2
else
    echo "ERROR: Failed to copy log file to $HOME_DIR." >&2
fi

# Send the log using eos-sendlog
if command -v eos-sendlog &>/dev/null; then
    echo "Sending log via eos-sendlog..." >&2
    cat "$LOG_FILE" | eos-sendlog
    echo "Log sent. Check terminal for URL." >&2
else
    echo "WARNING: 'eos-sendlog' command not found. Cannot send log automatically." >&2
    echo "You can manually upload the file located at '$HOME_DIR/$(basename "$LOG_FILE")'." >&2
fi

echo "Script finished."
