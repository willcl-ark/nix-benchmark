{ config, lib, pkgs, ... }:

{
  systemd.services.clone-bitcoin = {
    description = "Clone Bitcoin repository";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    unitConfig = {
      RefuseManualStart = true;
      RemainAfterExit = true;
    };

    serviceConfig = {
      Type = "oneshot";
      User = "satoshi";
      Group = "users";
    };

    script = ''
      if [ ! -d /home/satoshi/src/core/bitcoin ]; then
        mkdir -p /home/satoshi/src/core/bitcoin
        echo "use nix" >> /home/satoshi/src/core/.envrc
        ${pkgs.git}/bin/git clone https://github.com/bitcoin/bitcoin.git /home/satoshi/src/core/bitcoin
        ${pkgs.curl}/bin/curl -L https://raw.githubusercontent.com/0xB10C/nix-bitcoin-core/refs/heads/master/shell.nix -o /home/satoshi/src/core/shell.nix
      fi
    '';
  };
}
