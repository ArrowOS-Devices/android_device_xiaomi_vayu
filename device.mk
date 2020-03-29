#
# Copyright (C) 2018-2021 ArrowOS
#
# SPDX-License-Identifier: Apache-2.0
#

# Installs gsi keys into ramdisk, to boot a GSI with verified boot.
$(call inherit-product, $(SRC_TARGET_DIR)/product/gsi_keys.mk)

# Enable updating of APEXes
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# Shipping level
PRODUCT_SHIPPING_API_LEVEL := 30

# Dynamic partitions setup
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Fastbootd
PRODUCT_PACKAGES += \
    fastbootd \
    android.hardware.fastboot@1.0-impl-mock

# VNDK
PRODUCT_TARGET_VNDK_VERSION := 30

# Properties
include $(LOCAL_PATH)/product_prop.mk
PRODUCT_COMPATIBLE_PROPERTY_OVERRIDE := true

# File systems table
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/fstab.qcom:$(TARGET_COPY_OUT_RAMDISK)/fstab.default

# HIDL
PRODUCT_PACKAGES += \
    android.hidl.base@1.0 \
    android.hidl.manager@1.0

# HotwordEnrollement
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/privapp-permissions-hotword.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-hotword.xml

# Init scripts
PRODUCT_PACKAGES += \
    init.vayu.rc

# Lights
PRODUCT_PACKAGES += \
    android.hardware.light@2.0-service.vayu

# Releasetool scripts
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/bin/device_nfc_check.sh:install/bin/device_nfc_check.sh

# Telephony
PRODUCT_PACKAGES += \
    TelephonyResVayu

# NFC
PRODUCT_PACKAGES += \
    NfcNci \
    Tag \
    SecureElement \
    com.android.nfc_extras

# Overlays - override vendor ones
PRODUCT_PACKAGES += \
    FrameworksResCommon \
    FrameworksResTarget \
    DevicesOverlay \
    DevicesAndroidOverlay

include vendor/xiaomi/vayu/vayu-vendor.mk
