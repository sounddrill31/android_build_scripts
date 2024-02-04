#!/bin/bash

set -e
#Credit to Meghthedev for the initial script 

# Initialize repo with specified manifest
repo init --depth 1 -u https://github.com/LineageOS/android.git -b lineage-20.0 --git-lfs

# Run inside foss.crave.io devspace, in the project folder
# Remove existing local_manifests
crave run --no-patch -- "rm -rf .repo/local_manifests && \
# Remove these from previous runs
rm -rf frameworks/base vendor/plros/prebuilt/apps/Cromite ; \
cd packages/apps/Settings; git restore ; cd ../../.. \
# Initialize repo with specified manifest
repo init --depth 1 -u https://github.com/sounddrill31/plros_manifests.git -b lineage-20.0 --git-lfs && \
# Clone local_manifests repository
git clone https://github.com/sounddrill31/local_manifests --depth 1 -b lineage-oxygen .repo/local_manifests && \
# Sync the repositories
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags && \ 
# Apply microG patch to Settings app
wget -O packages/apps/Settings/microG.patch https://github.com/Divested-Mobile/DivestOS-Build/raw/master/Patches/LineageOS-20.0/android_packages_apps_Settings/0016-microG_Toggle.patch && \
cd packages/apps/Settings  && \
git patch -p1 -i *.patch && \
cd ../../.. && \
# Apply microG patch to frameworks/base
wget -O frameworks/base/microG.patch https://github.com/Divested-Mobile/DivestOS-Build/raw/master/Patches/LineageOS-20.0/android_frameworks_base/0036-Unprivileged_microG_Handling.patch && \
cd frameworks/base && \
git patch -p1 -i *.patch && \
cd ../.. && \
# Clone Cromite app
git clone https://gitlab.com/plros-lab/android_packages_apps_Cromite.git vendor/plros/prebuilt/apps/Cromite && \
# Set up build environment
source build/envsetup.sh && \
# Lunch configuration
lunch lineage_oxygen-userdebug && \
# Build the ROM
mka bacon && \
echo "Date and time:" && \
# Print out/build_date.txt
cat out/build_date.txt"

# Clean up
rm -rf oxygen



# Pull generated zip files
crave pull out/target/product/*/*.zip 

# Pull generated img files
crave pull out/target/product/*/*.img

# Upload zips to Telegram
telegram-upload --to sdreleases oxygen/*.zip
