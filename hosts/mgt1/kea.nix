{ isc-configs, ... }:
{
  services.kea = {
    dhcp4 = {
        enable = true;
        #configFile = builtins.fromJSON (builtins.readFile ./kea.json);
        configFile = "${isc-configs}/kea/kea.json";
    };
  };
 
  networking.firewall.allowedUDPPorts = [ 67 ];
   
}