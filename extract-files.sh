#!/bin/bash
#
# Copyright (C) 2020 The LineageOS Project
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

set -e

DEVICE=vayu
VENDOR=xiaomi

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ARROW_ROOT="${MY_DIR}"/../../..

HELPER="${ARROW_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

function blob_fixup() {
    case "${1}" in
        product/etc/permissions/vendor.qti.hardware.data.connection-V1.0-java.xml | product/etc/permissions/vendor.qti.hardware.data.connection-V1.1-java.xml)
            sed -i 's/xml version="2.0"/xml version="1.0"/' "${2}"
            ;;
    esac
}

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        -n | --no-cleanup )
                CLEAN_VENDOR=false
                ;;
        -k | --kang )
                KANG="--kang"
                ;;
        -s | --section )
                SECTION="${2}"; shift
                CLEAN_VENDOR=false
                ;;
        -f | --force )
                FORCE=true
                ;;
        * )
                SRC="${1}"
                ;;
    esac
    shift
done

if [ -z "${SRC}" ]; then
    SRC="adb"
fi

function blob_fixup() {
    case "${1}" in
    esac
}

# Initialize the helper for common device
setup_vendor "${DEVICE}" "${VENDOR}" "${ARROW_ROOT}" true "${CLEAN_VENDOR}"

extract "${MY_DIR}/proprietary-files.txt" "${SRC}" \
        "${KANG}" --section "${SECTION}"

"${MY_DIR}/setup-makefiles.sh"
