{ modulesPath, lib, pkgs, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./modules/users.nix
    ./modules/security.nix
    ./modules/packages.nix
    ./modules/system.nix
    ./clone-bitcoin.nix
    ./clone-benchooor.nix
  ];

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
}
