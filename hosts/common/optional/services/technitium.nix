{ lib, ... }:
{
  services.technitium-dns-server = {
    enable = true;
    openFirewall = true;
    # Whether to open ports in the firewall. 
    # Standard ports are 53 (UDP and TCP, for DNS), 5380 and 53443 (TCP, HTTP and HTTPS for web interface). 
    # Specify different or additional ports in options firewallUDPPorts and firewallTCPPorts if necessary.
  };

  systemd.services.technitium-dns-server.serviceConfig = {
         WorkingDirectory = lib.mkForce "/var/lib/private/technitium-dns-server";

  };
}
