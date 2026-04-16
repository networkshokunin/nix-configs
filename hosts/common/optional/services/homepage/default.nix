{ config, inputs, lib ,...}:
let
  cfg = config.services.homepage-dashboard;
  nix-var-acmePath = "${inputs.nix-secrets}/nix-vars/acme.nix";
  acmeConfig = import "${nix-var-acmePath}";

  nix-var-networkPath = "${inputs.nix-secrets}/nix-vars/network.nix";
  netConfig = (import nix-var-networkPath { inherit lib; }) { 
      hostname = config.hostSpec.hostName; 
    };
  mgt_network = netConfig.subnetProfiles.management.network;
in
{

  imports = builtins.filter (f: f != ./. + "/default.nix")
    (builtins.map (f: ./. + "/${f}") (builtins.attrNames (builtins.readDir ./.)));

  services.homepage-dashboard = {
    enable = true;
    openFirewall = true;
    allowedHosts = "${mgt_network}";
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