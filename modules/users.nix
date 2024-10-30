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

  home-manager.users.satoshi = with pkgs; {
    home.packages = [
      direnv
      fzf
      starship
      zoxide
    ];
    home.preferXdgDirectories = true;

    # Aliases which apply across all shells
    home.shellAliases = {
      vim = "nvim";
      ls = "eza";
      ll = "eza -al";
    };

    programs.bash.enable = true;
    # Add to .bashrc
    programs.bash.bashrcExtra = ''
      eval "$(direnv hook bash)"
      eval "$(zoxide init bash)"

      # FZF
      if command -v fzf-share >/dev/null; then
        source "$(fzf-share)/key-bindings.bash"
        source "$(fzf-share)/completion.bash"
      fi
    '';

    programs.direnv = {
      enableBashIntegration = true;
      package = pkgs.direnv;
      nix-direnv = {
        enable = true;
        package = pkgs.nix-direnv;
      };
    };

    programs.starship = {
      enable = true;
      settings = {
        directory.truncation_length = 2;
        gcloud.disabled = true;
        memory_usage.disabled = true;
        shlvl.disabled = false;
      };
    };

    # Have home-manager manage itself
    programs.home-manager.enable = true;
    home.stateVersion = "24.05";
  };

}
