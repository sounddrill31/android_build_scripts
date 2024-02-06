#!/bin/bash

set -e
#Credit to Meghthedev for the initial script 

# Initialize repo with specified manifest
repo init --depth 1 -u https://github.com/LineageOS/android.git -b lineage-20.0 --git-lfs

# Run inside foss.crave.io devspace, in the project folder
# Remove existing local_manifests
crave run --no-patch -- "rm -rf .repo/local_manifests && \
# Initialize repo with specified manifest
repo init --depth 1 -u https://github.com/sounddrill31/plros_manifests.git -b lineage-20.0 --git-lfs && \
# Clone local_manifests repository
git clone https://github.com/sounddrill31/local_manifests --depth 1 -b lineage-oxygen .repo/local_manifests && \
# Sync the repositories
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags && \ 
# Clone Cromite app
rm -rf vendor/plros/prebuilt/apps/Cromite;
git clone https://gitlab.com/plros-lab/android_packages_apps_Cromite.git vendor/plros/prebuilt/apps/Cromite && \
# Apply microG patch to frameworks/base
#cd frameworks/base && \
#git restore .  && \
#wget -O microG.patch https://github.com/lineageos4microg/docker-lineage-cicd/raw/master/src/signature_spoofing_patches/android_frameworks_base-Android13.patch && \
#patch -p1 -i microG.patch && \
#cd ../.. && \
# Apply microG patch to packages/modules/Permission
#cd packages/modules/Permission && \
#git restore .  && \
#wget -O microG.patch https://github.com/lineageos4microg/docker-lineage-cicd/raw/master/src/signature_spoofing_patches/packages_modules_Permission-Android13.patch && \
#patch -p1 -i microG.patch && \
#cd ../../.. && \
# Set up build environment
source build/envsetup.sh && \
# Lunch configuration
lunch lineage_oxygen-userdebug && \
# Build the ROM
mka bacon && \
echo "Date and time:" && \
# Print out/build_date.txt
cat out/build_date.txt
# Print SHA256
sha256sum out/target/product/*/*.zip"

# Clean up
rm -rf oxygen



# Pull generated zip files
crave pull out/target/product/*/*.zip 

# Pull generated img files
crave pull out/target/product/*/*.img

# Upload zips to Telegram
telegram-upload --to sdreleases oxygen/*.zip

#Upload to Github Releases
curl -sf https://raw.githubusercontent.com/Meghthedev/Releases/main/headless.sh | sh
