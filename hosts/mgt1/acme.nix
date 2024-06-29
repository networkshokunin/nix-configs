{ lib, config, nix-secrets, myvars, ... }:
let
  mgt1_secretsFile = "${nix-secrets}/hosts/mgt1/secrets.env";
in
{
  # Enable acme for usage with nginx vhosts
  security.acme = {
    acceptTerms = true;
    defaults = {
        email = myvars.email;
        credentialsFile = config.sops.secrets.acme.path;
        dnsProvider = "cloudflare";
        dnsResolver = "1.1.1.1:53";
        dnsPropagationCheck = true;  
        };
    certs = {
	  "${myvars.domain}" = {
        inheritDefaults = true;
        domain = "*.${myvars.domain}";
      };
    };
  };
  sops.secrets.acme = {
    sopsFile = "${mgt1_secretsFile}";
    format = "dotenv";
  };

  environment.persistence = {
    "/persistent" = {
      directories = [
        "/var/lib/acme"
      ];
    };
  };
}