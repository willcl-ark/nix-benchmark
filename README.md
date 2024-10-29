# NixOS benchmarking setup

## Deploy

To deploy to a server, either select and existing *disk-config*.nix*, or create a new one tailored to the target host.
This example will use a Hetzner AX52 as target, which comes with 2 SSDs located at /dev/nvme0* and */dev/nvme1*.

### Update SSH key

1. Update the SSH key in *configuration.nix* `openssh.authorizedKeys.keys` to one of your own.
2. Stage or commit the modification using `git` to include the modification in the build:
    ```bash
    git add configuration.nix
    git commit -m "update ssh key" # (optional)
    ```

```bash
$ nix-shell -p nixos-anywhere nixos-rebuild
[nix-shell:~]$ nixos-anywhere --flake .#ax52 --generate-hardware-config nixos-generate-config ./hardware-configuration.nix <hostname>
```


