#!/usr/bin/env bash

latest_version=$(curl -s https://api.github.com/repos/heptameta/project-meta/releases/latest | jq -r .tag_name | sed s/v//)
current_version=$(grep 'version = ' default.nix | sed 's/.*version = "\(.*\)";.*/\1/')

if [ "$latest_version" = "$current_version" ]; then
	echo "Already up to date"
	exit 0
fi
echo "Updating $current_version -> $latest_version"
echo "This will take a while..."

download_url="https://github.com/heptameta/project-meta/releases/download/v${latest_version}/Heptabase-${latest_version}.AppImage"
hash=$(curl -sL "$download_url" | sha256sum | cut -d' ' -f1)

sed -i "s~version = .*~version = \"$latest_version\";~" default.nix
sed -i "s~sha256 = .*~sha256 = \"$hash\";~" default.nix

echo "Success!"
