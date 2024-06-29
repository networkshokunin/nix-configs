{ isc-configs, ... }:
{
  services.kea = {
    dhcp4 = {
        enable = true;
        configFile = "${isc-configs}/kea/kea.json";
    };
    dhcp-ddns = {
        enable = true;
        configFile = "${isc-configs}/kea/ddns.json";
    };
  };
 
  networking.firewall.allowedUDPPorts = [ 67 ];
   
}