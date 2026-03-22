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

  config = lib.mkIf config.system.impermanence.enable (
    let
       rollbackScript = lib.readFile ./rollback-script.sh;
    in
    {
      boot.initrd = {
        supportedFilesystems = [ "btrfs" ];
        systemd.services.btrfs-rollback = {
          description = "Rollback BTRFS root subvolume to a pristine state";
          wantedBy = [ "initrd.target" ];
          requires = [ "dev-disk-by\\x2dlabel-BTRFS.device" ];
          after = [ "dev-disk-by\\x2dlabel-BTRFS.device" ];
          before = [ "sysroot.mount" ];
          unitConfig.DefaultDependencies = "no";
          serviceConfig.Type = "oneshot";
          script = builtins.readFile rollbackScript;
        };
      };

      fileSystems."${config.hostSpec.persistFolder}".neededForBoot = true;

      environment.persistence."${config.hostSpec.persistFolder}" = {
        hideMounts = true;
        directories = (
          lib.flatten (
            [
              "/var/log"
              "/var/lib/bluetooth"
              "/var/lib/nixos"
              "/var/lib/systemd/coredump"
              "/etc/NetworkManager/system-connections"
              {
                directory = "/var/lib/private";
                mode = "0700";
              }
              {
                directory = "/var/cache/private";
                mode = "0700";
              }
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
          "/etc/machine-id"
          "/etc/ssh/ssh_host_ed25519_key"
          "/etc/ssh/ssh_host_ed25519_key.pub"
          "/root/.ssh/known_hosts"
        ];
      };

      programs.fuse.userAllowOther = true;

      environment.systemPackages = [ btrfs-diff ];
    }
  );
}