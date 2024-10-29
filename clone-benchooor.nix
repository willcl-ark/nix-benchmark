{ config, lib, pkgs, ... }:

{
  systemd.services.clone-benchooor = {
    description = "Clone benchooor repository";
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
      if [ ! -d /home/satoshi/src/benchooor ]; then
        mkdir -p /home/satoshi/src
        ${pkgs.git}/bin/git clone https://github.com/bitcoin-dev-tools/benchooor.git /home/satoshi/src/benchooor
      fi
    '';
  };
}
