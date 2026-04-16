{ config, inputs, lib ,...}:
let
  cfg = config.services.homepage-dashboard;
  nix-var-acmePath = "${inputs.nix-secrets}/nix-vars/acme.nix";
  acmeConfig = import "${nix-var-acmePath}";
in
{

  imports = [
    ./settings.nix
    ./bookmarks.nix
    ./services.nix
    ./widgets.nix
  ];

  services.homepage-dashboard = {
    enable = true;
    openFirewall = true;
    allowedHosts = "admin.${acmeConfig.domain},127.0.0.1:${toString cfg.listenPort},localhost:${toString cfg.listenPort}";
    }; 

  services.nginx.virtualHosts."admin.${acmeConfig.domain}" = {
      useACMEHost = acmeConfig.domain; 
      forceSSL = true;            
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString cfg.listenPort}"; 
        proxyWebsockets = true;       
        recommendedProxySettings = true;
      };
    };
}