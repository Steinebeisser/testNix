#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
NIXOS_DIR="$SCRIPT_DIR/.."
DEVICE_DIR="$NIXOS_DIR/devices"
DEVICE="${1:-home-pc}"

if [ -z "${1-}" ]; then
    FLAG_ARG_SET=0
else
    FLAG_ARG_SET=1
fi

valid_options () {
    echo "Valid options are:"
    for dir in $DEVICE_DIR/*
    do
        if [[ ! -d $dir ]]; then
            continue
        fi
        dir=${dir%*/}
        echo " - ${dir##*/}"
    done
}

if [[ ! -d "$DEVICE_DIR/$DEVICE" ]]; then
    echo "ERROR: Device directioy '$DEVICE_DIR/$DEVICE' does not exist." >&2
    valid_options
    exit 1
fi

read -p "Using device '$DEVICE' for rebuild [y/n] (y): " yn
case $yn in
    [Yy]*) ;;
    [Nn]*) 
        echo "Aborted"
        if [[ $FLAG_ARG_SET -eq 0 ]]; then
            echo "Correct usage: $0 [device-name]"
            valid_options
        fi
        exit  1
        ;;
esac

pushd "$DEVICE_DIR/$DEVICE"

echo "Formatting .nxi files with alejandra..."
find . -type f -name '*.nix' -exec alejandra {} +

git diff -U0 *.nix

echo "NixOS Rebuilding ..."
sudo nixos-rebuild switch --flake "$NIXOS_DIR#$DEVICE"  &>nixos-switch.log || (cat nixos-switch.log | grep --color error && false)

gen_info=$(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | grep '(current)')
gen_num=$(echo "$gen_info" | awk '{print $1}')
gen_date=$(echo "$gen_info" | awk '{print $2, $3}')
gen_msg="Generation $gen_num - $gen_date"

temp_dir="$HOME/.local/share/rebuild"
mkdir -p "$temp_dir"

temp_file=$(mktemp "$temp_dir/$(basename "$0").XXXXXXXXXX")
trap 'rm -f -- "$temp_file"' EXIT
echo "$gen_msg" > "$temp_file"

git add *.nix
git commit -e -F "$temp_file"

rm "$temp_file"

popd
