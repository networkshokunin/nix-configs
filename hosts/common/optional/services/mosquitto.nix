{ lib, inputs, config, ... }:
let
  isImpermanent = config.system ? "impermanence" && config.system.impermanence.enable;

  mosquittoFilePath = "${inputs.nix-secrets}/sops/mosquitto.yaml";

  nix-var-networkPath = "${inputs.nix-secrets}/nix-vars/network.nix";
  netConfig = (import nix-var-networkPath { inherit lib; }) { 
      hostname = "sidecar-iot"; 
    };

in
{
  sops.secrets = lib.mkMerge [
    {
      "passwords/mqtt"      = { sopsFile = mosquittoFilePath; };
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
          hashedPasswordFile = config.sops.secrets."passwords/mqtt".path; 
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