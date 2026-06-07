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
let 
  nix-var-networkPath = "${inputs.nix-secrets}/nix-vars/network.nix";
  netConfig-iot = (import nix-var-networkPath { inherit lib; }) { 
      hostname = "sidecar-iot"; 
    };
  netConfig-users = (import nix-var-networkPath { inherit lib; }) { 
      hostname = "sidecar-users"; 
    };
in
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
      "hosts/common/optional/services/qemu-agent.nix"
      "hosts/common/optional/network.nix" # network configuration based on hostSpec
      "hosts/common/optional/services/openssh.nix" # allow remote SSH access
      "hosts/common/optional/services/acme.nix" # ACME client for automatic TLS certs
      "hosts/common/optional/services/nginx.nix" # Nginx web server
      "hosts/common/optional/services/chrony.nix"
      "hosts/common/optional/services/mosquitto.nix" # Mosquitto MQTT broker
      "hosts/common/optional/services/podman.nix" # Podman container runtime
      "hosts/common/optional/services/scrypted.nix" # Scrypted home automation server
      "hosts/common/optional/services/zigbee2mqtt.nix" # Zigbee2MQTT bridge
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

  systemd.network.links."10-mgt" = {
    matchConfig.PermanentMACAddress = "bc:24:11:b3:33:24";
    linkConfig.Name = "mgt";
  };

  systemd.network.links."20-iot" = {
    matchConfig.MACAddress = "bc:24:11:34:0c:0d";
    linkConfig.Name = "iot";
  };

  systemd.network.links."30-users" = {
    matchConfig.MACAddress = "bc:24:11:a3:01:c3";
    linkConfig.Name = "users";
  };

  networking = {
    interfaces."${netConfig-iot.interface}" = {
      ipv4.addresses = [{
        address = netConfig-iot.address;
        prefixLength =  netConfig-iot.prefixLength;
      }];
    };
    interfaces."${netConfig-users.interface}" = {
      ipv4.addresses = [{
        address = netConfig-users.address;
        prefixLength =  netConfig-users.prefixLength;
      }];
    };
  };

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "26.05";
}
