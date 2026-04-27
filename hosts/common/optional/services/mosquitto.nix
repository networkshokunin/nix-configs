{ lib, inputs, config, ... }:
let
  isImpermanent = config.system ? "impermanence" && config.system.impermanence.enable;

  sopsFolder = builtins.toString inputs.nix-secrets;
  mosquittoFilePath = "${sopsFolder}/sops/mosquitto.yaml";

  nix-var-networkPath = "${inputs.nix-secrets}/nix-vars/network.nix";
  netConfig = (import nix-var-networkPath { inherit lib; }) { 
      hostname = "sidecar-iot"; 
    };

in
{
  sops.secrets.mosquitto = lib.mkMerge [
    {
      "mqttPassword" = { sopsFile = mosquittoFilePath; };
    }
  ];

  services.mosquitto = {
    enable = true;
    listeners = [
      {
        address = netConfig.address;
        port = 1883;
        omitPasswordAuth = false;
        settings.allow_anonymous = false;

        users.mqtt = {
          acl = [ "readwrite #" ];
          # In Nix, we usually manage the password file externally for security:
          hashedPasswordFile = config.sops.secrets.mosquitto.mqttPassword; 
        };
      }
    ];
    persistence = true;
    dataDir = "/var/lib/mosquitto";
  };
}