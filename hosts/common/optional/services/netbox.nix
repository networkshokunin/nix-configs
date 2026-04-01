{ lib, inputs, config, ... }:
let
  isImpermanent = config.system ? "impermanence" && config.system.impermanence.enable;  
  nix-var-acmePath = "${inputs.nix-secrets}/nix-vars/acme.nix";
  acmeConfig = import "${nix-var-acmePath}";
in  
{

  services.netbox = {
    enable = true;
    secretKeyFile = config.sops.secrets."netbox/secretKey".path;
    listenAddress = "127.0.0.1"; 
  };

  services.nginx.virtualHosts."netbox.${acmeConfig.domain}" = {
    forceSSL = true;
    useACMEHost = "${acmeConfig.domain}";
      locations = {
        "/" = {
            proxyPass = "http://${config.services.netbox.listenAddress}:${toString config.services.netbox.port}";
        };
        "/static/" = { alias = "${config.services.netbox.dataDir}/static/"; };
      };
  };

  users.users.nginx.extraGroups = [ "netbox" ];

  environment.persistence."${config.hostSpec.persistFolder}".directories = lib.mkIf isImpermanent [
      "/var/lib/netbox"
    ];
}
