{ config, lib, ... }:
let
  sopsFolder = builtins.toString inputs.nix-secrets;
  acmeEnv = "${sopsFolder}/sops/acme.env";

  nix-var-acmePath = "${inputs.nix-secrets}/nix-vars/acme.nix";
  acmeConfig = import "${nix-var-acmePath}";

in
{
  # Enable acme for usage with nginx vhosts
  security.acme = {
    acceptTerms = true;
    defaults = {
        email = acmeConfig.email;
        credentialsFile = config.sops.secrets.acme.path;
        dnsProvider = acmeConfig.provider;
        dnsResolver = acmeConfig.resolver;
        dnsPropagationCheck = true;  
        # group = "nginx";
        };
    certs = {
	  "${acmeConfig.domain}" = {
        inheritDefaults = true;
        domain = "*.${config.hostSpec.domain}";
      };
    };
  };
  sops.secrets.acme = {
    sopsFile = acmeEnv;
    format = "dotenv";
  };

  environment.persistence."${config.hostSpec.persistFolder}".directories = [
      "/var/lib/private/technitium-dns-server"
    ];
}