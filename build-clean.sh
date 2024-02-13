#!/bin/bash

set -e
#Credit to Meghthedev for the initial script 

# Initialize repo with specified manifest
 repo init -u https://github.com/crdroidandroid/android.git -b 14.0 --git-lfs
 
# Run inside foss.crave.io devspace, in the project folder
# Remove existing local_manifests
crave run --clean  --no-patch -- "rm -rf .repo/local_manifests prebuilts/gcc/linux-x86/x86/x86_64-linux-android-4.9 && \

# Initialize repo with specified manifest
repo init -u https://github.com/AOSPA/manifest -b uvite --depth 1 --git-lfs && \

# Clone local_manifests repository
git clone https://github.com/sounddrill31/local_manifests --depth 1 -b aospa-oxygen .repo/local_manifests && \

# Sync the repositories
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags && \ 

# Set up build environment
source build/envsetup.sh && \


# Lunch configuration
lunch aospa_oxygen-userdebug && \

# Build the ROM
rm -rf out/target/product/oxygen/ ; \
./rom-build.sh oxygen && \
echo "Date and time:" && \

# Print out/build_date.txt
cat out/build_date.txt; echo \

# Print SHA256
sha256sum out/target/product/*/*.zip"

# Clean up
rm -rf oxygen/



# Pull generated zip files
crave pull out/target/product/*/*.zip 

# Pull generated img files
crave pull out/target/product/*/*.img

# Upload zips to Telegram
telegram-upload --to sdreleases oxygen/*.zip oxygen/recovery.img

#Upload to Github Releases
#cd oxygen/
#curl -sf https://raw.githubusercontent.com/Meghthedev/Releases/main/headless.sh | sh
