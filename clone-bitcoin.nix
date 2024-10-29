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
      User = "will";
      Group = "users";
    };

    script = ''
      if [ ! -d /home/will/src/bitcoin ]; then
        mkdir -p /home/will/src
        ${pkgs.git}/bin/git clone https://github.com/bitcoin/bitcoin.git /home/will/src/bitcoin
      fi
    '';
  };
}
