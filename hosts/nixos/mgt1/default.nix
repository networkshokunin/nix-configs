#############################################################
#
#  Mgt1
#
###############################################################

{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = lib.flatten [
    #
    # ========== Hardware ==========
    #
    ./hardware-configuration.nix

    (lib.custom.scanPaths ./.) # Load all host-specific *.nix files

    (map lib.custom.relativeToRoot [
      #
      # ========== Required Configs ==========
      #
      "hosts/common/core"

      # ========== Optional Configs ==========
      #
      "hosts/common/optional/network.nix" # network configuration based on hostSpec
      "hosts/common/optional/services/openssh.nix" # allow remote SSH access
      "hosts/common/optional/services/acme.nix" # ACME client for automatic TLS certs
      "hosts/common/optional/services/nginx.nix" # Nginx web server
      "hosts/common/optional/services/technitium.nix" # Technitium DNS Server
      "hosts/common/optional/services/chrony.nix" # Chrony NTP client and server
      "hosts/common/optional/realtek_usb_ethernet.nix" # Udev rules for Realtek USB ethernet adapters
    ])
  ];

  #
  # ========== Host Specification ==========
  #

  system.impermanence = {
    enable = config.hostSpec.isImpermanent;
    autoPersistHomes = true;
  };

  boot.loader = {
    systemd-boot = {
      enable = true;
      # When using plymouth, initrd can expand by a lot each time, so limit how many we keep around
      configurationLimit = lib.mkDefault 5;
    };
    efi.canTouchEfiVariables = true;
    timeout = 3;
  };

  boot.initrd = {
    systemd.enable = true;
    systemd.emergencyAccess = true;
  };

  hardware.graphics = {
    enable = true;
  };

  # # https://nixos.org/manual/nixos/stable/#sec-rename-ifs
  # systemd.network.links."10-1Gb" = {
  #   matchConfig.PermanentMACAddress = "7c:83:34:bc:0c:67";
  #   linkConfig.Name = "mgmt";
  # };

  systemd.network.links."20-2.5Gb" = {
    matchConfig.PermanentMACAddress = "9c:47:82:fb:b9:92";
    linkConfig.Name = "server";
  };

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.11";
}
