{ inputs, pkgs, ... }:
let
  nix-var-acmePath = "${inputs.nix-secrets}/nix-vars/acme.nix";
  acmeConfig = import "${nix-var-acmePath}";
in  
{

  services.librespeed = {
    enable = true;

  };

  services.nginx.virtualHosts."speedtest.${acmeConfig.domain}" = {
    forceSSL = true;
    useACMEHost = "${acmeConfig.domain}";
    locations."/".proxyPass = "http://127.0.0.1:8989";
  };

}
