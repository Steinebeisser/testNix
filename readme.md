# nixos installation guide

> [!WARNING]
> Currently still in configuration, not recommended to use as allot still doesnt work correctly like nvim lsp's
> As soon as its in a useable state repo will also be renamed

## 1. Boot from iso

Either create a bootable usb stick \
or \
add iso to your bootloader (possible with grub, dont know about systemd)

## 2. Disk Partitioning

I like `cfdisk` but theres also `parted`

use `lsblk` tp identify target disk

launch `cfdisk` to partition correct disk

```bash
cfdisk /dev/nvme0
```
> _Replace `/dev/nvme0` etc. with your actual device names as seen with `lsblk`_

### My Partitioning Scheme

- 1G with type `EFI System`
- 4G `SWAP`
- Rest `Linux filesystem`

> [!NOTE]
> Im soon gonna add disko to do the partitioning

## 3. Formatting Partitions

Partition as said in the [Installation Guide](https://nixos.wiki/wiki/NixOS_Installation_Guide#Partitioning)

- EFI

```bash
mkfs.fat -F 32 -n boot /dev/nvme0n1
```

- filesystem

```bash
mkfs.ext4 -L mnt /dev/nvme0n3
```

- SWAP

```bash
mkswap -L swap /dev/nvme0n2
```

## 4. Mounting

- root

```bash
mount /dev/nvme0n3 /mnt
```

- boot

```bash
mount --mkdir /dev/nvme0n1 /mnt/boot
```

- swap

```bash
swapon /dev/nvme0n2
```

## 5. Generate Inition Config

used for hardware config and initial install

```bash
nixos-generate-config --root /mnt
```

## 6. Install initial config

Install nixos to get out of install medium and be able to install my config

```bash
cd /mnt
nixos-install
```

reboot after

## 7. Clone Repo

```bash
mkdir -p  /etc/steinflake
git clone https://github.com/Steinebeisser/testNix.git /etc/steinflake
```

> [!WARNING]
> Need to rename Repo

## 8. Copy your Hardware Config

to get correct config for your device

```bash
rm /etc/steinflake/nixos/hardware-configuration.nix
cp /etc/nixos/hardware-configuration.nix /etc/steinflake/nixos
```

## 9. Regenerate Nixos with config

```bash
nixos-rebuild switch --flake /etc/steinflake#stein-btw
```

## 10. Additionl Tip

If you want to have goated Setup, consider getting inspired by my [dotfiles Repo](https://github.com/Steinebeisser/Dotfiles)
