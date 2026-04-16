{ inputs, ... }:
let
  # Keep as a path type to avoid unnecessary string conversion
  acmeConfig = import (inputs.nix-secrets + "/nix-vars/acme.nix");
in  
{
  services.homepage-dashboard.bookmarks = [
    {
      "Network" = [
        {
          "Unifi" = [
            {
              icon = "unifi.png";
              href = "https://unifi.${acmeConfig.domain}";
              description = "Unifi Controller";
            }
          ];
        }
        {
          "Netbox" = [
            {
              icon = "netbox.png";
              href = "https://netbox.${acmeConfig.domain}";
              description = "Netbox Inventory Management";
            }
          ];
        }
        {
          "Access Switch - Management" = [
            {
              icon = "tplink.png";
              href = "https://asw-mgt.ib.${acmeConfig.domain}";
              description = "Access Switch - Management";
            }
          ];
        }
        {
          "Access Switch - Parents" = [
            {
              icon = "tplink.png";
              href = "https://asw-parents.ib.${acmeConfig.domain}";
              description = "Access Switch - Parents";
            }
          ];
        }
        {
          "Access Switch - Living Room" = [
            {
              icon = "tplink.png";
              href = "https://asw-livingrm.ib.${acmeConfig.domain}";
              description = "Access Switch - Living Room";
            }
          ];
        }
      ];
    }
  ];
}