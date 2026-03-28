{ lib, inputs, config, ... }:
let
  isImpermanent = config.system ? "impermanence" && config.system.impermanence.enable;
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
        group = config.services.nginx.group;
        renewInterval = "*-*-* 00/03:00:00";
        };
    certs = {
	  "${acmeConfig.domain}" = {
        inheritDefaults = true;
        domain = "*.${acmeConfig.domain}";
        reloadServices = [ "nginx" ];
      };
    };
  };
  sops.secrets.acme = {
    sopsFile = acmeEnv;
    format = "dotenv";
  };

  config = lib.mkIf ( isImpermanent ) {
    environment.persistence."${config.hostSpec.persistFolder}".directories = [
      "/var/lib/acme"
    ];
  };

}