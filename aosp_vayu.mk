#
# Copyright (C) 2018-2021 ProjectArcana
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit common products
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit device configurations
$(call inherit-product, device/xiaomi/vayu/device.mk)

# Inherit common ArrowOS configurations
$(call inherit-product, vendor/aosp//common.mk)


PRODUCT_NAME := aosp_vayu



PRODUCT_DEVICE := vayu
PRODUCT_BRAND := POCO
PRODUCT_MODEL := Poco X3 Pro
PRODUCT_MANUFACTURER := Xiaomi

#Arcana stuff
TARGET_BOOT_ANIMATION_RES := 1080

ARCANA_DEVICE := VAYU




#Grapheneos camera
TARGET_BUILD_GRAPHENEOS_CAMERA= true

#Lawnchair
PREBUILT_LAWNCHAIR := true

#Apn
COPY_APN_SYSTEM := true

#Blur
#TARGET_SUPPORTS_BLUR := true

#quick tap
TARGET_SUPPORTS_QUICK_TAP := true

#Gapps
#TARGET_GAPPS_ARCH := arm64
#WITH_GAPPS := true


PRODUCT_GMS_CLIENTID_BASE := android-xiaomi

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="vayu_global-user 11 RKQ1.200826.002 V12.5.7.0.RJUMIXM release-keys" \
    PRODUCT_NAME=vayu_global \
    PRODUCT_MODEL=M2102J20SI

BUILD_FINGERPRINT := Xiaomi/vayu_global/vayu:11/RKQ1.200826.002/V12.5.7.0.RJUMIXM:user/release-keys


#Maintainer Stuff
ARCANA_MAINTAINER = DEAFAULTER
ARCANA_OFFICIAL = false
