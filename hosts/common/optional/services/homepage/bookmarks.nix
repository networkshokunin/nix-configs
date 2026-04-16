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
              icon = "tp-link.png";
              href = "https://asw-mgt.ib.${acmeConfig.domain}";
              description = "Access Switch - Management";
            }
          ];
        }
        {
          "Access Switch - Parents" = [
            {
              icon = "tp-link.png";
              href = "https://asw-parents.ib.${acmeConfig.domain}";
              description = "Access Switch - Parents' Room";
            }
          ];
        }
        {
          "Access Switch - Living Room" = [
            {
              icon = "tp-link.png";
              href = "https://asw-livingrm.ib.${acmeConfig.domain}";
              description = "Access Switch - Living Room";
            }
          ];
        }
        {
          "Access Switch - Pantry" = [
            {
              icon = "tp-link.png";
              href = "https://asw-pantry.ib.${acmeConfig.domain}";
              description = "Access Switch - Pantry";
            }
          ];
        }
        {
          "Access Switch - DB Box" = [
            {
              icon = "tp-link.png";
              href = "https://asw-dbbox.ib.${acmeConfig.domain}";
              description = "Access Switch - DB Box";
            }
          ];
        }
        {
          "Access Switch - DB Box" = [
            {
              icon = "tp-link.png";
              href = "https://asw-dbbox.ib.${acmeConfig.domain}";
              description = "Access Switch - DB Box";
            }
          ];
        }
        {
          "Access Switch - Master Bedroom" = [
            {
              icon = "tp-link.png";
              href = "https://asw-mbr.ib.${acmeConfig.domain}";
              description = "Access Switch - Master Bedroom";
            }
          ];
        }
        {
          "Access Switch - Olivia" = [
            {
              icon = "tp-link.png";
              href = "https://asw-olivia.ib.${acmeConfig.domain}";
              description = "Access Switch - Olivia's Room";
            }
          ];
        }
        {
          "Access Switch - Bryan" = [
            {
              icon = "tp-link.png";
              href = "https://asw-bryan.ib.${acmeConfig.domain}";
              description = "Access Switch - Bryan's Room";
            }
          ];
        }
        {
          "Access Switch - Xavier" = [
            {
              icon = "tp-link.png";
              href = "https://asw-xavier.ib.${acmeConfig.domain}";
              description = "Access Switch - Xavier's Room";
            }
          ];
        } 
      ];
    }
  ];
}