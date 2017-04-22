#!/bin/bash

# ------------------------------------------------------------
# Case Sensitive Mount Script for the Auvenir Development Team
# ------------------------------------------------------------

# Configuration
WORKSPACE=${HOME}/.workspace.dmg.sparseimage
MOUNTPOINT=${HOME}/workspace
VOLUME_NAME=workspace
VOLUME_SIZE=10g
REPO_URL=https://github.com/Auvenir/Auvenir.git
REPO_FOLDER=Auvenir

# Create a sparse bundle with the correct parameters, as the original user
create() {
    sudo -u $SUDO_USER bash -c "hdiutil create -type SPARSE -fs 'Case-sensitive Journaled HFS+' -size ${VOLUME_SIZE} -volname ${VOLUME_NAME} '${WORKSPACE}'"
}

# Mount the workspace volume on boot
automount() {
    attach
    cat << EOF > /tmp/com.workspace.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>RunAtLoad</key>
        <true/>
        <key>Label</key>
        <string>com.workspace</string>
        <key>ProgramArguments</key>
        <array>
            <string>hdiutil</string>
            <string>attach</string>
            <string>-notremovable</string>
            <string>-nobrowse</string>
            <string>-mountpoint</string>
            <string>${MOUNTPOINT}</string>
            <string>${WORKSPACE}</string>
        </array>
    </dict>
</plist>
EOF
    cp /tmp/com.workspace.plist /Library/LaunchDaemons/com.workspace.plist
    rm /tmp/com.workspace.plist
}

# Unmount the workspace volume
detach() {
    m=$(hdiutil info | grep "${MOUNTPOINT}" | cut -f1)
    if [ ! -z "$m" ]; then
        hdiutil detach $m
    fi
}

# Mount the workspace volume
attach() {
    hdiutil attach -notremovable -nobrowse -mountpoint "${MOUNTPOINT}" "${WORKSPACE}"
}

# Clean up the workspace volume
compact() {
    detach
    hdiutil compact "${WORKSPACE}" -batteryallowed
    attach
}

# Check for root
if [[ $UID -ne 0 ]]; then
  echo 'This commands needs to be run as root.  Use sudo.'
  exit 1
fi


echo "This will install the code to ${MOUNTPOINT}"
echo "The code will run off a proper case-sensitive volume."

# Step 1 Create the Volume
echo -n "Creating case-insensitive volume ... "
[[ ! -f "${WORKSPACE}" ]] && create
echo "done."

# Step 2 Mount the Volume
echo -n "Mounting the volume ... "
m=$(hdiutil info | grep "${MOUNTPOINT}" | cut -f1)
[[ -z $m ]] && attach
echo "done."

# Step 3 Automount Enable
echo -n "Enabling mount at boot ... "
automount
echo "done."

# Step 4 Clone Git Repo
echo "Cloning the code repo ... "
cd "${MOUNTPOINT}"
[[ ! -d "${MOUNTPOINT}/${REPO_FOLDER}" ]] && git clone "${REPO_URL}"
echo "done."

# Step 5 Initial Build
echo "Completing the first build ..."
cd "${MOUNTPOINT}/${REPO_FOLDER}"
sudo -u $SUDO_USER bash -c "./docker/local/build.sh new"

echo
echo
echo "The code is installed at: ${MOUNTPOINT}"
echo
