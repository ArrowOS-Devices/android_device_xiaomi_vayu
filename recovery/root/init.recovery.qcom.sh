#!/system/bin/sh
# Make recovery permissive
setenforce 0
# Wait for some time to avoid us being overridden
sleep 5
# Make symlinks from /dev/block/mapper to /dev/block/bootdevice/by-name
# For compatibility with mods like Magisk and OpenGapps
# (vendor and system should be more than enough)
ln -sf /dev/block/mapper/system /dev/block/bootdevice/by-name/system
ln -sf /dev/block/mapper/vendor /dev/block/bootdevice/by-name/vendor
