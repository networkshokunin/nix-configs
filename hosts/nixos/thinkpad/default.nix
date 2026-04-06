#############################################################
#
#  Thinkpad
#
###############################################################

{
  inputs,
  lib,
  config,
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

      #      #
      # ========== Optional Configs ==========
      #
      # FIXME(starter): add or remove any optional host-level configuration files the host will use
      # The following are for example sake only and are not necessarily required.
      "hosts/common/optional/services/openssh.nix" # allow remote SSH access
      "hosts/common/optional/audio.nix" # pipewire and cli controls
      "hosts/common/optional/services/cosmic.nix"
      "hosts/common/optional/services/1password.nix"
      "hosts/common/optional/services/fingerprint.nix"
      "hosts/common/optional/services/screen.nix"
    ])
  ];

  #
  # ========== Host Specification ==========
  #

  system.impermanence = {
    enable = config.hostSpec.isImpermanent;
    autoPersistHomes = true;
  };

  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
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
  };

  hardware.graphics = {
    enable = true;
  };

  systemd.network.links."20-wired" = {
    matchConfig.PermanentMACAddress = "84:a9:38:08:c5:51";
    linkConfig.Name = "wired";
  };

  systemd.network.links."30-wireless" = {
    matchConfig.PermanentMACAddress = "94:e2:3c:88:0c:61";
    linkConfig.Name = "wifi";
  };

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.11";
}
