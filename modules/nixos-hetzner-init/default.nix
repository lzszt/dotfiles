{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.nixos-hetzner-init;

  create-hetzner-vm = pkgs.writeScriptBin "create-hetzner-vm" ''
    set -e
    CREATE_RESPONSE=$(hcloud server create --image ubuntu-26.04 --name test-nixos --type cx23 --location fsn1 -o json)
    SERVER_ID=$(echo $CREATE_RESPONSE | jq '.server.id')
    SERVER_IP4=$(echo $CREATE_RESPONSE | jq -r '.server.public_net.ipv4.ip')
    SERVER_ROOT_PASSWORD=$(echo $CREATE_RESPONSE | jq -r '.root_password')

    hcloud server attach-iso $SERVER_ID nixos-minimal-26.05.4364.0ad6f47ea4fe-x86_64-linux.iso

    hcloud server reboot $SERVER_ID
  '';

  server-id = "164231982";

  server-ip = "2.28.37.121";

  nixos-generate-config = pkgs.writeScriptBin "nixos-generate-config" ''
    set -e

    parted --script -f /dev/sda -- mklabel msdos
    parted --script -f /dev/sda -- mkpart primary 1MB -2GB
    parted --script -f /dev/sda -- set 1 boot on
    parted --script -f /dev/sda -- mkpart primary linux-swap -2GB 100%

    mkfs.ext4 -F -L nixos /dev/sda1
    mkswap -f -L swap /dev/sda2

    while [ ! -e /dev/disk/by-label/nixos ]; do
        sleep 0.5
    done

    mount /dev/disk/by-label/nixos /mnt
    swapon /dev/sda2

    nixos-generate-config --root /mnt
  '';

  generate-config = pkgs.writeScriptBin "generate-config" ''
    set -e

    scp ${nixos-generate-config}/bin/nixos-generate-config root@${server-ip}:/root
    hcloud server ssh ${server-id} "/root/nixos-generate-config"
    HARDWARE_CONFIG=$(hcloud server ssh ${server-id} "cat /mnt/etc/nixos/hardware-configuration.nix")

    echo $HARDWARE_CONFIG
  '';
in
{
  options.modules.nixos-hetzner-init = {
    enable = lib.mkEnableOption "nixos-hetzner-init";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.hcloud
      create-hetzner-vm
      nixos-generate-config
      generate-config
    ];
  };
}
