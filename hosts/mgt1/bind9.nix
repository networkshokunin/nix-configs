{ config, isc-configs, ... }:
{
  environment.etc = {
    "zone_files/db.domain.com".source = "${isc-configs}/bind9/zone_files/db.domain.com";
    "zone_files/db.1.in-addr.arpa".source = "${isc-configs}/bind9/zone_files/db.1.in-addr.arpa";
    "zone_files/db.2.in-addr.arpa".source = "${isc-configs}/bind9/zone_files/db.2.in-addr.arpa";
    "zone_files/db.3.in-addr.arpa".source = "${isc-configs}/bind9/zone_files/db.3.in-addr.arpa";
    "zone_files/db.4.in-addr.arpa".source = "${isc-configs}/bind9/zone_files/db.4.in-addr.arpa";
    "zone_files/db.5.in-addr.arpa".source = "${isc-configs}/bind9/zone_files/db.5.in-addr.arpa";
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
