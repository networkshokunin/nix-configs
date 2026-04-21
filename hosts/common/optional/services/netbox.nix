{ lib, inputs, config, ... }:
let
  isImpermanent = config.system ? "impermanence" && config.system.impermanence.enable;  
  nix-var-acmePath = "${inputs.nix-secrets}/nix-vars/acme.nix";
  acmeConfig = import "${nix-var-acmePath}";
  sopsFolder = builtins.toString inputs.nix-secrets;
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
    extraConfig = ''
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_set_header X-Forwarded-Host $host;
    '';
    locations = {
      "/" = {
          proxyPass = "http://${config.services.netbox.listenAddress}:${toString config.services.netbox.port}";
      };
      "/static/" = { alias = "${config.services.netbox.dataDir}/static/"; };
    };
  };

  users.users.nginx.extraGroups = [ "netbox" ];

  sops.secrets = lib.mkMerge [
    {
      "netbox/secretKey" = {
        sopsFile = "${sopsFolder}/secrets.yaml";
        owner = "netbox";
        group = "netbox";
        mode = "0400";
        restartUnits = [ "netbox.service" ];
      };
    }
  ];

  environment.persistence."${config.hostSpec.persistFolder}".directories = lib.mkIf isImpermanent [
      "/var/lib/netbox"
      "/var/lib/postgresql"
      "/var/lib/redis-netbox"
    ];
}