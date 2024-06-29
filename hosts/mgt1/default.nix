{myvars, pkgs, disko, ...}:
#############################################################
#
#  mgmt1 - management server with NixOS
#
#############################################################
let
  hostName = "mgt1"; # Define your hostname.
in {
  imports = [
    disko.nixosModules.default
    (import ./disko.nix { device = "/dev/nvme0n1"; })
    #./netdev-mount.nix
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./impermanence.nix
    ./chrony-server.nix
    ./bind9.nix
    ./adguardhome.nix
    ./acme.nix
    ./nginx.nix
    ./kea.nix
    ./unifi.nix
  ];

  networking = {
    inherit hostName;
    inherit (myvars.networking) defaultGateway nameservers;
    inherit (myvars.networking.hostsInterface.${hostName}) interfaces;

    # desktop need its cli for status bar
    networkmanager.enable = true;
  };

  # conflict with feature: containerd-snapshotter
  # virtualisation.docker.storageDriver = "btrfs";

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libvdpau-va-gl
    ];
  };

  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; }; # Force intel-media-driver

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
