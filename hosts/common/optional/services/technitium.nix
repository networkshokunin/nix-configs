{ lib, inputs, config, pkgs, ... }:
let
  isImpermanent = config.system ? "impermanence" && config.system.impermanence.enable;
  nix-var-acmePath = "${inputs.nix-secrets}/nix-vars/acme.nix";
  acmeConfig = import "${nix-var-acmePath}";

  nix-var-networkPath = "${inputs.nix-secrets}/nix-vars/network.nix";
  netConfig = (import nix-var-networkPath { inherit lib; }) { 
      hostname = config.hostSpec.hostName; 
    };
  mgmt_network = netConfig.subnetData.management;
  mgmt_wireguard_network = netConfig.subnetData.wireguard_mgmt;
in  
{

  services.technitium-dns-server = {
    package = pkgs.unstable.technitium-dns-server;
    enable = true;
    openFirewall = true;
    # Whether to open ports in the firewall. 
    # Standard ports are 53 (UDP and TCP, for DNS), 5380 and 53443 (TCP, HTTP and HTTPS for web interface). 
    # Specify different or additional ports in options firewallUDPPorts and firewallTCPPorts if necessary.
  };

  systemd.services.technitium-dns-server.serviceConfig = {
         WorkingDirectory = lib.mkForce "/persist/var/lib/private/technitium-dns-server";

  };

  services.nginx.virtualHosts."technitium.${acmeConfig.domain}" = {
    forceSSL = true;
    useACMEHost = "${acmeConfig.domain}";
    locations."/".proxyPass = "http://127.0.0.1:5380";
	  extraConfig = ''
		  #proxy_set_header Host $host;
      allow ${mgmt_network};
      allow ${mgmt_wireguard_network};
      allow 127.0.0.1;      
    
      deny all;
	  '';
  };

  environment.persistence."${config.hostSpec.persistFolder}".directories = lib.mkIf isImpermanent [
      "/var/lib/private/technitium-dns-server"
    ];

  # disable systemd-resolved to avoid conflicts with technitium dns server
  services.resolved.enable = false;

}
