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
  sops.secrets."mosquitto/mqttPassword" = {
    sopsFile = mosquittoFilePath;
  };

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
          hashedPasswordFile = config.sops.secrets."mosquitto/mqttPassword".path; 
        };
      }
    ];
    persistence = true;
    dataDir = "/var/lib/mosquitto";
  };

  environment.persistence."${config.hostSpec.persistFolder}".directories = lib.mkIf isImpermanent [
      "/var/lib/mosquitto"
    ];
}