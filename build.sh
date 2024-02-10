#!/bin/bash

set -e
#Credit to Meghthedev for the initial script 

# Initialize repo with specified manifest
repo init --depth 1 -u https://github.com/LineageOS/android.git -b lineage-20.0 --git-lfs

# Run inside foss.crave.io devspace, in the project folder
# Remove existing local_manifests
crave run --no-patch -- "rm -rf .repo/manifests .repo/local_manifests platform/prebuilts/vndk/v32 prebuilts/vndk/v32 hardware/qcom-caf/msm8953/audio vendor/plros && \

# Print out Build URL
echo "Build URL is: https://foss.crave.io/app/\#/build/info/${DCJOBID}?team=14" ; \

# Initialize repo with specified manifest
repo init --depth=1 -u https://github.com/burhancodes/lmodroid.git -b thirteen --git-lfs && \

# Replace mirrors
sed -i 's|fetch="https://git.libremobileos.com"|fetch="https://github.com"|g' .repo/manifests/snippets/lmodroid.xml ; \

# Clone local_manifests repository
git clone https://github.com/sounddrill31/local_manifests --depth 1 -b lmodroid-oxygen .repo/local_manifests && \

# Sync the repositories
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags && \ 
# git clone https://android.googlesource.com/platform/prebuilts/vndk/v32 platform/prebuilts/vndk/v32
# Set up build environment
source build/envsetup.sh && \

# Add microG
git clone https://github.com/lineageos4microg/android_vendor_partner_gms vendor/partner_gms; \
export WITH_GMS=true; \

# Lunch configuration
lunch lmodroid_oxygen-userdebug && \

# Build the ROM
rm -rf out/target/product/oxygen/ ; \
make clean && \
mka bacon && \
echo "Date and time:" && \

# Print out/build_date.txt
cat out/build_date.txt; echo \

# Print SHA256
sha256sum out/target/product/*/*.zip"

# Clean up
rm -rf oxygen



# Pull generated zip files
crave pull out/target/product/*/*.zip 

# Pull generated img files
crave pull out/target/product/*/*.img

# Upload zips to Telegram
telegram-upload --to sdreleases oxygen/*.zip oxygen/recovery.img

#Upload to Github Releases
# cd oxygen/
# curl -sf https://raw.githubusercontent.com/Meghthedev/Releases/main/headless.sh | sh
