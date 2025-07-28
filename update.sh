#!/usr/bin/env bash

loading() {
    local pid=$1
    local delay=0.1
    local spin='/-\|'

    while ps -p $pid > /dev/null; do
        for i in $(seq 0 3); do
            echo -ne "\r${spin:i:1}  "
            sleep $delay
        done
    done
    echo -ne "\r"
}

latest_version=$(curl -s https://api.github.com/repos/heptameta/project-meta/releases/latest | jq -r .tag_name | sed s/v//)
current_version=$(grep 'version = ' default.nix | sed 's/.*version = "\(.*\)";.*/\1/')

if [ "$latest_version" = "$current_version" ]; then
	echo "Already up to date"
	exit 0
fi
echo "Updating $current_version -> $latest_version"

download_url="https://github.com/heptameta/project-meta/releases/download/v${latest_version}/Heptabase-${latest_version}.AppImage"
hash=$(curl -sL "$download_url" | sha256sum | cut -d' ' -f1) &

pid=$!
loading $pid
wait $pid

sed -i "s~version = .*~version = \"$latest_version\";~" default.nix
sed -i "s~sha256 = .*~sha256 = \"$hash\";~" default.nix

echo "Success!"
