#!/bin/bash

set -e

# Initialize repo with specified manifest
 repo init -u https://github.com/crdroidandroid/android.git -b 14.0 --git-lfs

# Run inside foss.crave.io devspace, in the project folder
# Remove existing local_manifests
crave run --no-patch -- "rm -rf .repo/local_manifests && \
# Initialize repo with specified manifest
repo init --depth=1 -u https://github.com/sounddrill31/local_manifest-2 -b patch-1 && \

# Clone local_manifests repository
git clone https://github.com/projectelixeroscar/local_manifest.git --depth 1 -b master .repo/local_manifests && \

# Removals
rm -rf system/libhidl prebuilts/clang/host/linux-x86 prebuilt/*/webview.apk platform/external/python/pyfakefs platform/external/python/bumble external/chromium-webview/prebuilt/x86_64 platform/external/opencensus-java vendor/qcom/opensource/commonsys-intf/display && \

# Sync the repositories
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags && \ 

# Set up build environment
source build/envsetup.sh && \

# Lunch configuration and Build
make clean && \
lunch aosp_oscar-user && \
export TZ=Asia/Dhaka && \
croot ;\
mka bacon -j$(nproc --all); \

echo "Date and time:" ; \

# Print out/build_date.txt
cat out/build_date.txt; echo; \

# Print SHA256
sha256sum out/target/product/*/*.zip"

# Clean up
# rm -rf tissot/*



# Pull generated zip files
# crave pull out/target/product/*/*.zip 

# Pull generated img files
# crave pull out/target/product/*/*.img

# Upload zips to Telegram
# telegram-upload --to sdreleases tissot/*.zip

#Upload to Github Releases
#curl -sf https://raw.githubusercontent.com/Meghthedev/Releases/main/headless.sh | sh
