#############################################################
#
#  Thinkpad
#
###############################################################

{
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

    #
    # ========== Disk Layout ==========
    #
    #inputs.disko.nixosModules.disko
    #(lib.custom.relativeToRoot "hosts/common/disks/btrfs-disk.nix")
    #{
    #  _module.args = {
    #    disk = "/dev/nvme0n1";
    #    withSwap = true;
    #    swapSize = 16;
    #  };
    #}

    (map lib.custom.relativeToRoot [
      #
      # ========== Required Configs ==========
      #
      "hosts/common/core"

      #      #
      # ========== Optional Configs ==========
      #
      "hosts/common/optional/services/openssh.nix" # allow remote SSH access
    ])
  ];

  #
  # ========== Host Specification ==========
  #

  hostSpec = {
    hostName = "mgt1";
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
  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.11";
}
