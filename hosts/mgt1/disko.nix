{
  device ? throw "Set this to your disk device, e.g. /dev/sda",
  ...
}:
{
  # required by impermanence
  fileSystems."/persistent".neededForBoot = true;

  disko.devices = {
    disk.main = {
      inherit device;
      #device = "/dev/mmcblk0"; # The device to partition
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            priority = 1;
            name = "ESP";
            start = "1M";
            end = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          swap = {
            size = "64G";
            content = {
              type = "swap";
            };
          };
          root = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ]; # Override existing partition
              # Subvolumes must set a mountpoint in order to be mounted,
              # unless their parent is mounted
              subvolumes = {
                "@" = { };
                # https://github.com/chewblacka/nixos/blob/main/disko-config.nix
                # Root subvolume
                "@/root" = {
                  mountOptions = [ "compress=zstd:1" "noatime" ];
                  mountpoint = "/";
                };
                # Nix data, including the store
                "@/nix" = {
                  mountOptions = [ "compress=zstd:1" "noatime" "nodev" "nosuid" ];
                  mountpoint = "/nix";
                };
                # Persistent data
                "@/persistent" = {
                  mountOptions = [ "compress=zstd:1" "noatime" "nodev" "nosuid" "noexec" ];
                  mountpoint = "/persistent";
                };
                "@/snapshots" = {
                  mountOptions = [ "compress=zstd:1" "noatime" "nodev" "nosuid"];
                  mountpoint = "/snapshots";
                };
                # System logs
                "@/log" = {
                  mountOptions = [ "compress=zstd:1" "noatime" "nodev" "nosuid" "noexec" ];
                  mountpoint = "/var/log";
                };
              };
            };
          };
        };
      };
    };
  };
}

