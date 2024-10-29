{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    include-what-you-use
    gitlint
    gofmt
    mdformat
    pyright
    ruff
    rust_analyzer
    shellcheck
    shfmt
    stylua
    zls
  ];

  xdg.configFile.nvim.source = pkgs.fetchFromGitHub {
      owner = "willcl-ark";
      repo = "neovim";
      rev = "6172f78ed334bed7475a87ac122f941f65f2f0a5";
      sha256 = "sha256-IJqnPQANaBK+m7ursx+71oRcG6Dh23b9il/jtWWzQXI=";
  };
}
