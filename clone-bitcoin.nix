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
      if [ ! -d /home/satoshi/src/bitcoin ]; then
        mkdir -p /home/satoshi/src
        ${pkgs.git}/bin/git clone https://github.com/bitcoin/bitcoin.git /home/satoshi/src/bitcoin
      fi
    '';
  };
}
