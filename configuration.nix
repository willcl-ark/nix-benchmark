{ modulesPath
, lib
, pkgs
, ...
}:
let
  ssh_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH988C5DbEPHfoCphoW23MWq9M6fmA4UTXREiZU0J7n0 will.hetzner@temp.com";
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./clone-bitcoin.nix
    ./clone-benchooor.nix
  ];
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  environment.systemPackages = with pkgs; [
    bash
    bat
    btop
    cargo
    ccache
    curl
    direnv
    eza
    fastfetch
    fd
    fish
    flamegraph
    gdb
    git
    hdparm # Disk performance measurement
    hexdump
    htop
    hyperfine
    just
    kernelshark # Kernel trace visualization
    linuxKernel.packages.linux_6_6.systemtap
    linuxPackages.perf # Kernel perf events
    lmdb
    lshw # Hardware configuration info
    magic-wormhole
    mosh
    neovim
    ninja
    perf-tools
    pkg-config
    procps # System and process monitoring
    python310
    ripgrep
    rocksdb
    rustup
    starship
    sqlite
    strace
    sysstat # System performance tools (sar, iostat, etc)
    time
    tmux
    trace-cmd # Kernel trace utility
    uv
  ];

  programs.direnv = {
    package = pkgs.direnv;
    silent = false;
    loadInNixShell = true;
    direnvrcExtra = "";
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
      memory_usage.disabled = true; # because it includes cached memory it's reported as full a lot
      shlvl.disabled = false;
    };
  };

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "less";
  };

  # Firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ]; # SSH
    # allowedUDPPorts = [ ... ];
    # allow ping/ICMP:
    allowPing = true;
  };

  # Security hardening
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "yes";
      AllowTcpForwarding = "no";
      X11Forwarding = false;
    };
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false; # passwordless sudo
  };

  time.timeZone = "UTC";

  nix = {
    # Automatic garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  # Better system monitoring
  services = {
    # for SSH protection
    fail2ban = {
      enable = true;
      maxretry = 5;
      bantime = "24h";
    };

    # System monitoring and logs
    journald.extraConfig = ''
      SystemMaxUse=500M
      MaxRetentionSec=1month
    '';

    # Better SSD support
    fstrim = {
      enable = true;
      interval = "weekly";
    };
  };

  environment.interactiveShellInit = ''
    eval "$(direnv hook bash)"
  '';

  users = {
    users.root = {
      openssh.authorizedKeys.keys = [
        ssh_key
      ];
    };

    users.satoshi = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        ssh_key
      ];
      extraGroups = [ "wheel" ]; # For sudo access
      home = "/home/satoshi";
    };
  };

  system.stateVersion = "24.05";
}
