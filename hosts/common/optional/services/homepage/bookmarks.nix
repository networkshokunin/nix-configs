{ inputs, ... }:
let
  nix-var-acmePath = "${inputs.nix-secrets}/nix-vars/acme.nix";
  acmeConfig = import "${nix-var-acmePath}";
in  
{
  services.homepage-dashboard.bookmarks =  {
      "Network" = [
        {
          "unifi" = {
            icon = "unifi.png"; # Uses the dashboard-icons name
            href = "https://unifi.${acmeConfig.domain}";
            description = "Unifi Controller";
            #ping = "unifi.${acmeConfig.domain}"; # Optional: Host to ping for status (can be used with showStats to show status on the dashboard)
          };
        }
      ];
    };
}

