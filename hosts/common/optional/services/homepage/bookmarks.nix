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
      ];
    }
  ];
}