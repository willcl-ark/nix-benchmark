{ modulesPath
, lib
, pkgs
, ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
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
    bat
    binutils
    bison
    boost
    btop
    cargo
    ccache
    cmake
    curl
    direnv
    eza
    fastfetch
    fd
    fish
    flamegraph
    gcc13
    gdb
    git
    hdparm # Disk performance measurement
    htop
    hyperfine
    just
    kernelshark # Kernel trace visualization
    libevent
    libsystemtap
    linuxKernel.packages.linux_6_6.systemtap
    linuxPackages.perf # Kernel perf events
    llvm_18
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
    sqlite
    strace
    sysstat # System performance tools (sar, iostat, etc)
    time
    tmux
    trace-cmd # Kernel trace utility
    uv
    valgrind
  ];

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
      PermitRootLogin = "no";
      AllowTcpForwarding = "no";
      X11Forwarding = false;
    };
  };

  time.timeZone = "UTC";

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
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

  users = {
    users.satoshi = {
      isNormalUser = true;
      # shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH988C5DbEPHfoCphoW23MWq9M6fmA4UTXREiZU0J7n0 will.hetzner@temp.com"
      ];
      extraGroups = [ "wheel" ]; # For sudo access
    };
  };

  system.stateVersion = "24.05";
}
