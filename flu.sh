#!/bin/bash

# Block Flussonic updates, block domains, and update license
# Author: SmartNull

echo "🔹 Blocking Flussonic package updates..."
for pkg in flussonic flussonic-erlang flussonic-transcoder flussonic-transcoder-base flussonic-qsv; do
    if apt-cache show "$pkg" >/dev/null 2>&1; then
        sudo apt-mark hold "$pkg"
        echo "$pkg set on hold."
    else
        echo "Package $pkg not found, skipping..."
    fi
done

echo "🔹 Backing up the hosts file..."
sudo cp /etc/hosts /etc/hosts.bak

echo "🔹 Blocking Flussonic and Erlyvideo domains in /etc/hosts..."
HOSTS_BLOCK=(
    "apt.flussonic.com"
    "license.flussonic.com"
    "flussonic.com"
    "flussonic.cloud"
    "erlyvideo.org"
)

for host in "${HOSTS_BLOCK[@]}"; do
    if ! grep -q "$host" /etc/hosts; then
        echo "127.0.0.1 $host" | sudo tee -a /etc/hosts >/dev/null
        echo "Blocked $host"
    else
        echo "$host already blocked"
    fi
done

echo "🔹 Fixing license file permissions..."
sudo chattr -i /etc/flussonic/license.txt
sudo chown root:root /etc/flussonic/license.txt
sudo chmod 644 /etc/flussonic/license.txt

echo "🔹 Updating license key..."
cat <<EOF | sudo tee /etc/flussonic/license.txt >/dev/null
l4|AbOFvyPq7piW0ub_MfFUL2|r6BzpmVPpjgKpn9IunpFp6lLbCZOp3
EOF

echo "✅ Flussonic blocking and license update completed successfully."
