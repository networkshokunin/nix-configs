{ lib, inputs, ... }:
let
  nix-var-acmePath = "${inputs.nix-secrets}/nix-vars/acme.nix";
  acmeConfig = import "${nix-var-acmePath}";
in  
{

  services.librespeed = {
    enable = true;
    domain = "speedtest.${acmeConfig.domain}"; 
    frontend = {
      enable = true;
      useNginx = true;
      contactEmail = "admin@example.com";
    };
    settings = {
      enable_tls = false; 
    };
  };

  services.nginx.virtualHosts."speedtest.${acmeConfig.domain}" = {
    useACMEHost = "${acmeConfig.domain}";
	  extraConfig = ''
		  proxy_set_header Host $host;
	  '';
  };
}
