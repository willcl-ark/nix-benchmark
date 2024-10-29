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
      User = "will";
      Group = "users";
    };

    script = ''
      if [ ! -d /home/will/src/benchooor ]; then
        mkdir -p /home/will/src
        ${pkgs.git}/bin/git clone https://github.com/bitcoin-dev-tools/benchooor.git /home/will/src/benchooor
      fi
    '';
  };
}
