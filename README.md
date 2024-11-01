# NixOS benchmarking setup

## Deploy

To deploy to a server, either select and existing *disk-config\*.nix*, or create a new one tailored to the target host.
This example will use a Hetzner AX52 as target, which comes with 2 SSDs located at */dev/nvme1n1* and */dev/nvme0n1*.

### Update SSH key

1. Update the SSH key in *modules/users.nix* `ssh_key` to one of your own.
2. Stage or commit the modification using `git` to include the modification in the build:
    ```bash
    git add modules/users.nix
    git commit -m "update ssh key" # (optional)
    ```

### Load NixOS configuration

```bash
$ nix-shell -p nixos-anywhere
[nix-shell:~]$ nixos-anywhere --flake .#ax52 root@<ip_address>
```

## Update

```bash
$ nix-shell -p nixos-rebuild
[nix-shell:~]$ nixos-rebuild switch --flake .#ax52 --target-host root@<ip_address>
```
