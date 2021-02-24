#!/sbin/sh
#
# Copyright (C) 2020 The ArrowOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

REGION=`getprop ro.boot.hwc`
SYSDEV="$(readlink -nf "$1")"
SYSFS="$2"

determine_system_mount() {
  if grep -q -e"^$SYSDEV" /proc/mounts; then
    umount $(grep -e"^$SYSDEV" /proc/mounts | cut -d" " -f2)
  fi

  if [ -d /mnt/system ]; then
    SYSMOUNT="/mnt/system"
  elif [ -d /system_root ]; then
    SYSMOUNT="/system_root"
  else
    SYSMOUNT="/system"
  fi

  export S=$SYSMOUNT/system
}

mount_system() {
  mount -t $SYSFS $SYSDEV $SYSMOUNT -o rw,discard
}

unmount_system() {
  umount $SYSMOUNT
}

determine_system_mount

if [ $REGION == "INDIA" ]; then
    mount_system
    # Nuke NFC
    rm -rf $S/app/*Nfc*
    rm -rf $S/etc/permissions/*nfc*
    rm -rf $S/framework/*nfc*
    rm -rf $S/lib/*nfc*
    rm -rf $S/lib64/*nfc*
    rm -rf $S/priv-app/Tag
fi

# unmount system
unmount_system
