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

  imports = lib.builtins.filter (f: f != ./default.nix)
    (lib.builtins.map (f: ./. + "/${f}") (lib.builtins.attrNames (lib.builtins.readDir ./.)));

  services.homepage-dashboard = {
    enable = true;
    openFirewall = true;
    allowedHosts = "${mgt_network}";
    }; 

  services.nginx.virtualHosts."admin.${acmeConfig.domain}" = {
    useACMEHost = "${acmeConfig.domain}";
    locations."${cfg.location}" = {
      proxyPass = "http://127.0.0.1:${toString cfg.port}/";
      proxyWebsockets = true;
      recommendedProxySettings = true;
    };
	  extraConfig = ''
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
	  '';
    proxyWebsockets = true;
    recommendedProxySettings = true;
  };
}