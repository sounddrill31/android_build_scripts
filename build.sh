#!/bin/bash

set -e
#Credit to Meghthedev for the initial script 

# Initialize repo with specified manifest
repo init -u https://github.com/ArrowOS/android_manifest.git -b arrow-13.1

# Run inside foss.crave.io devspace
# Remove existing local_manifests & Clone local_manifests repository

crave run --no-patch -- "rm -rf .repo/local_manifests ; mkdir .repo/local_manifests ;\
cd .repo/local_manifests ; wget https://raw.githubusercontent.com/sounddrill31/local_manifests_mithorium/Arrow-13.1/Arrow-13.1-SSI.xml ; cd ../.. ; \   
 
# Sync the repositories
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags && \ 

# Set up build environment
source build/envsetup.sh && \

# Lunch configuration
lunch arrow_MiThoriumSSI-userdebug && \

# Build the ROM
make systemimage"

# Clean up
rm -rf MiThoriumSSI 



# Pull generated zip files
crave pull out/target/product/*/*.zip

# Pull generated img files
crave pull out/target/product/*/*.img 

# Upload zips to Telegram
telegram-upload --to OkBuddyGSI MiThoriumSSI/*.zip
