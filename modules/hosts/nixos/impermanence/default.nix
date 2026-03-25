{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  options.system.impermanence = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.hostSpec.isImpermanent;
      description = "Enable impermanence";
    };
    # FIXME: Actually use this in the script, but need to use the substituteAll approach
    removeTmpFilesOlderThan = lib.mkOption {
      type = lib.types.int;
      default = 14;
      description = "Number of days to keep old btrfs_tmp files";
    };
    autoPersistHomes = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Automatically persist all user's home directories

        This currently assumes you want permission "u=rwx,g=,o=" and
        your user is in "users" group.
      '';
    };
  };

  options.environment = {
    persist = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Files and directories to persist in the home";
    };
  };

  # FIXME(impermanence): Indicate the subvolume to backup
  config = lib.mkIf config.system.impermanence.enable {
      boot.initrd.systemd = {
        enable = true; # this enabled systemd support in stage1 - required for the below setup
        services.rollback = {
          description = "Rollback BTRFS root subvolume to a pristine state";
          wantedBy = ["initrd.target"];
          after = ["initrd-root-device.target"];
          # Before mounting the system root (/sysroot) during the early boot process
          before = ["sysroot.mount"];

          unitConfig.DefaultDependencies = "no";
          serviceConfig.Type = "oneshot";
          script = ''
            mkdir -p /mnt
            mount -o subvol=/ /dev/disk/by-label/BTRFS /mnt

            btrfs subvolume list -o /mnt/root |
              cut -f9 -d' ' |
              while read subvolume; do
                echo "deleting /$subvolume subvolume..."
                btrfs subvolume delete "/mnt/$subvolume"
              done &&
              echo "deleting /root subvolume..." &&
              btrfs subvolume delete /mnt/root
            echo "restoring blank /root subvolume..."
            btrfs subvolume snapshot /mnt/root-blank /mnt/root

            # Once we're done rolling back to a blank snapshot,
            # we can unmount /mnt and continue on the boot process.
            umount /mnt
          '';
        };
      };

      fileSystems."${config.hostSpec.persistFolder}".neededForBoot = true;

      environment.persistence."${config.hostSpec.persistFolder}" = {
        directories = (
          lib.flatten (
            [
              "/var/log"
              "/var/lib/bluetooth" # move to bluetooth-specific
              "/var/lib/nixos"
              "/var/lib/systemd/coredump"
              "/etc/NetworkManager/system-connections"
              "/var/db/sudo"
            ]
            ++ lib.optional config.system.impermanence.autoPersistHomes (
            map (user: {
              directory = "${if pkgs.stdenv.isDarwin then "/Users" else "/home"}/${user}";
              inherit user;
              group = if pkgs.stdenv.isDarwin then "staff" else "users";
              mode = "u=rwx,g=,o=";
            }) config.hostSpec.users
            )
          )
        );
        files = [
          # Essential. If you don't have these for basic setup, you will have a bad time
          "/etc/machine-id"
          "/etc/ssh/ssh_host_ed25519_key"
          "/etc/ssh/ssh_host_ed25519_key.pub"
          "/etc/ssh/ssh_host_rsa_key"
          "/etc/ssh/ssh_host_rsa_key.pub"

          # Non-essential
          "/root/.ssh/known_hosts"
        ];
      };
      programs.fuse.userAllowOther = true; # allow non-root users to use fuse (e.g. for sshfs)
    };
}