{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Development tools
    cargo
    git
    gh
    ninja
    pkg-config
    python310
    rustup
    uv

    # System monitoring
    btop
    flamegraph
    htop
    kernelshark
    linuxPackages.perf
    perf-tools
    procps
    sysstat
    trace-cmd

    # Debug tools
    gdb
    strace

    # Shell utilities
    bat
    curl
    direnv
    eza
    fd
    just
    mosh
    neovim
    ripgrep
    starship
    tmux

    # Database
    lmdb
    rocksdb
    sqlite

    # System tools
    ccache
    hdparm
    hexdump
    lshw
    magic-wormhole
    time
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
      memory_usage.disabled = true;
      shlvl.disabled = false;
    };
  };
}
