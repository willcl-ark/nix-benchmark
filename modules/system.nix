{ config, lib, pkgs, ... }:
{
  time.timeZone = "UTC";

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  services = {
    journald.extraConfig = ''
      SystemMaxUse=500M
      MaxRetentionSec=1month
    '';

    fstrim = {
      enable = true;
      interval = "weekly";
    };
  };

  environment = {
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      PAGER = "less";
    };

    interactiveShellInit = ''
      eval "$(direnv hook bash)"
    '';
  };

  system.stateVersion = "unstable";
}
