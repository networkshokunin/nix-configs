{ lib, inputs, config, ... }:
let
  isImpermanent = config.system ? "impermanence" && config.system.impermanence.enable;  
  nix-var-acmePath = "${inputs.nix-secrets}/nix-vars/acme.nix";
  acmeConfig = import "${nix-var-acmePath}";
in  
{
  services.netbox = {
    enable = true;
    secretKeyFile = config.sops.secrets."netbox".path; 
  };

  services.nginx.virtualHosts."netbox.${acmeConfig.domain}" = {
    forceSSL = true;
    useACMEHost = "${acmeConfig.domain}";
    locations = {
      "/static/" = {
        alias = "${config.services.netbox.dataDir}/static/";
      };
      "/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.netbox.port}";
        proxyWebsockets = true;
        recommendedProxySettings = true;
      };
  };
  };

  environment.persistence."${config.hostSpec.persistFolder}".directories = lib.mkIf isImpermanent [
      "/var/lib/netbox"
    ];
}
