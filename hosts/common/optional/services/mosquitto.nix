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
        address = "127.0.0.1";
        port = 1883;
        omitPasswordAuth = false;
        settings.allow_anonymous = false;
        
        users.mqtt = {
          acl = [ "readwrite #" ];
          hashedPasswordFile = config.sops.secrets."passwords/mqtt".path; 
        };
      }
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

  networking.firewall.allowedTCPPorts = [ 1883 ];

  environment.persistence."${config.hostSpec.persistFolder}".directories = lib.mkIf isImpermanent [
      "/var/lib/mosquitto"
    ];
}