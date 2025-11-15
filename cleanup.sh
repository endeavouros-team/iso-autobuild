#!/bin/sh
echo "Cleaning up ISO build structure..."
rm -rf "EndeavourOS-ISO/work"
rm -rf EndeavourOS-ISO/airootfs/etc/pacman.d/
echo "Cleaning up large temporary directories..."
rm -rf node_modules dist build logs tmp .cache
# check filesystem size

# show free space on all filesystems
df -hT

# show blocks/sectors in bytes for the target path (adjust path to your build output)
TARGET=/path/to/EndeavourOS-ISO/out
df -B1 "$TARGET"

# show where TARGET is mounted
mount | grep "$(readlink -f $TARGET)" -B1 || true

# show largest files in the airootfs
WS=EndeavourOS-ISO/work/x86_64/airootfs
du -sh "$WS" || true
du -h --max-depth=2 "$WS" | sort -hr | head -n 40
