{ config, isc-configs, ... }:
{
  system.activationScripts.bind-zones.text = ''
    mkdir -p /etc/bind/zones
    chown named:named /etc/bind/zones
  '';

  environment.etc = {
    "bind/zones/db.domain.com" = {
      enable = true;
      source = "${isc-configs}/bind9/zone_files/db.domain.com";
      user = "named";
      group = "named";
      mode = "0644";
    };
    "bind/zones/db.1.in-addr.arpa" = {
      enable = true;
      source = "${isc-configs}/bind9/zone_files/db.1.in-addr.arpa";
      user = "named";
      group = "named";
      mode = "0644";      
    };
    "bind/zones/db.2.in-addr.arpa" = {
      enable = true;
      source = "${isc-configs}/bind9/zone_files/db.2.in-addr.arpa";
      user = "named";
      group = "named";
      mode = "0644";      
    };
    "bind/zones/db.3.in-addr.arpa" = {
      enable = true;
      source = "${isc-configs}/bind9/zone_files/db.3.in-addr.arpa";
      user = "named";
      group = "named";
      mode = "0644";      
    };
    "bind/zones/db.4.in-addr.arpa" = {
      enable = true;
      source = "${isc-configs}/bind9/zone_files/db.4.in-addr.arpa";
      user = "named";
      group = "named";
      mode = "0644";      
    };
    "bind/zones/db.5.in-addr.arpa" = {
      enable = true;
      source = "${isc-configs}/bind9/zone_files/db.5.in-addr.arpa";
      user = "named";
      group = "named";
      mode = "0644";      
    };
  };

  services.bind = {
    enable = true;
    ipv4Only = true;
    configFile = "${isc-configs}/bind9/named.master.conf";
  };
 
  networking.firewall.allowedTCPPorts = [ 5353 ];
  networking.firewall.allowedUDPPorts = [ 5353 ];
   
}

#ref: https://github.com/cleverca22/nixos-configs/blob/b87de522a2d41db9697908f749ab89bf4441e57e/router.nat.nix#L114
#ref: https://github.com/holochain/holochain-infra/blob/fa3d1091e05ca382f8a59a5760ae4c9db1907efd/modules/flake-parts/nixosConfigurations.dweb-reverse-tls-proxy/configuration.nix#L192
