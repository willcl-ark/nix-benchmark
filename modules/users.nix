{ config, lib, pkgs, ... }:
let
  ssh_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH988C5DbEPHfoCphoW23MWq9M6fmA4UTXREiZU0J7n0 will.hetzner@temp.com";
in
{
  users = {
    users.root = {
      openssh.authorizedKeys.keys = [ ssh_key ];
    };

    users.satoshi = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [ ssh_key ];
      extraGroups = [ "wheel" ];
      home = "/home/satoshi";
    };
  };
}
