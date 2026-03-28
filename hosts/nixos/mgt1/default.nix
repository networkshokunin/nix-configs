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
      "hosts/common/services" # LLDP network topology discovery daemon


      # ========== Optional Configs ==========
      #
      "hosts/common/optional/network.nix" # network configuration based on hostSpec
      "hosts/common/optional/services/openssh.nix" # allow remote SSH access
      "hosts/common/optional/services/acme.nix" # ACME client for automatic TLS certs
      "hosts/common/optional/services/nginx.nix" # Nginx web server
      "hosts/common/optional/services/technitium.nix" # Technitium DNS Server
      "hosts/common/optional/services/chrony.nix" # Chrony NTP client and server
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
  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.11";
}
