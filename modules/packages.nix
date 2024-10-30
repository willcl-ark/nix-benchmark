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
    eza
    fd
    just
    mosh
    neovim
    ripgrep
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
}
