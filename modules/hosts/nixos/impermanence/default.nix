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

  config = lib.mkIf config.system.impermanence.enable {
    boot.initrd.systemd.services.rollback = {
      description = "Rollback BTRFS root subvolume to a pristine state";
      wantedBy = ["initrd-root-device.target"];
      before = ["sysroot.mount"];
      after = ["systemd-udev-settle.service"];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";

      script = ''
        mkdir -p /mnt

        # We first mount the btrfs root to /mnt
        # so we can manipulate btrfs subvolumes.
        mount -o subvol=/ /dev/disk/by-partlabel/disk-main-root /mnt

        # While we're tempted to just delete /root and create
        # a new snapshot from /root-blank, /root is already
        # populated at this point with a number of subvolumes,
        # which makes `btrfs subvolume delete` fail.
        # So, we remove them first.
        #
        # /root contains subvolumes:
        # - /root/var/lib/portables
        # - /root/var/lib/machines
        #
        # I suspect these are related to systemd-nspawn, but
        # since I don't use it I'm not 100% sure.
        # Anyhow, deleting these subvolumes hasn't resulted
        # in any issues so far, except for fairly
        # benign-looking errors from systemd-tmpfiles.
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

      fileSystems."${config.hostSpec.persistFolder}".neededForBoot = true;

      # NOTE: This is a list of directories and files that we want to persist across reboots for all systems
      # per-system lists are provided in hosts/<host>/
      environment.persistence."${config.hostSpec.persistFolder}" = {
          directories =
            [
              "/var/log"
              "/var/lib/bluetooth" # move to bluetooth-specific
              "/var/lib/nixos"
              "/var/lib/systemd/coredump"
              "/etc/NetworkManager/system-connections"
            ]
            ++ config.hostSpec.impermanenceDirectories;
        # directories = (
        #   lib.flatten (
        #     [
        #       "/var/log"
        #       "/var/lib/bluetooth" # move to bluetooth-specific
        #       "/var/lib/nixos"
        #       "/var/lib/systemd/coredump"
        #       "/etc/NetworkManager/system-connections"

        #       # systemd DynamicUser requires /var/{lib,cache}/private to exist and be 0700
        #       # FIXME: I don't entirely understand why this happens sometimes... a service works, then on rebuild
        #       # it tries to migrate to use a */private/* version and fails because of 755 perms. Then often requires
        #       # manual 700 modification to fix if I forget to add this first.
        #       {
        #         directory = "/var/lib/private";
        #         mode = "0700";
        #       }
        #       {
        #         directory = "/var/cache/private";
        #         mode = "0700";
        #       }

        #     ]
        #     ++ lib.optional config.system.impermanence.autoPersistHomes (
        #       map (user: {
        #         directory = "${if pkgs.stdenv.isDarwin then "/Users" else "/home"}/${user}";
        #         inherit user;
        #         # FIXME: Can't use config.users.users here due to recursion, despite
        #         # old code using it okay?
        #         #group = config.users.users.${user}.group;
        #         group = if pkgs.stdenv.isDarwin then "staff" else "users";
        #         mode = "u=rwx,g=,o=";
        #       }) config.hostSpec.users
        #     )
        #   )
        # );
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

      programs.fuse.userAllowOther = true;
    };
}