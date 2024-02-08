#!/bin/bash

set -e
#Credit to Meghthedev for the initial script 

# Initialize repo with specified manifest
repo init --depth 1 -u https://github.com/LineageOS/android.git -b lineage-20.0 --git-lfs

# Run inside foss.crave.io devspace
# Remove existing local_manifests
crave run --clean --no-patch -- "rm -rf .repo/local_manifests && \

# Clone local_manifests repository
git clone https://github.com/sounddrill31/local_manifests --depth 1 -b lineage-oxygen .repo/local_manifests && \

 # Sync the repositories
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags && \ 

# Set up build environment
source build/envsetup.sh && \

# Lunch configuration
lunch lineage_oxygen-userdebug && \

# Build the ROM
mka bacon"

# Clean up
rm -rf oxygen 



# Pull generated zip files
crave pull out/target/product/*/*.zip

# Pull generated img files
crave pull out/target/product/*/*.img 

# Upload zips to Telegram
telegram-upload --to sdreleases oxygen/*.zip
