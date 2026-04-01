{ lib, inputs, config, pkgs, ... }:
let
  isImpermanent = config.system ? "impermanence" && config.system.impermanence.enable;
  nix-var-acmePath = "${inputs.nix-secrets}/nix-vars/acme.nix";
  acmeConfig = import "${nix-var-acmePath}";
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
      allow 10.168.10.0/24;
      allow 10.168.200.0/24;  
      allow 127.0.0.1;      
    
      deny all;
	  '';
  };

  environment.persistence."${config.hostSpec.persistFolder}".directories = [
      "/var/lib/private/technitium-dns-server"
    ];

  # disable systemd-resolved to avoid conflicts with technitium dns server
  services.resolved.enable = false;

}
