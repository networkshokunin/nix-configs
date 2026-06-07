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

  # Inject CF_API_EMAIL and CF_DNS_API_TOKEN into the lego renewal service.
  # systemd reads EnvironmentFile as root so default sops permissions (root:root 0400) work.
  systemd.services."acme-order-renew-${acmeConfig.domain}".serviceConfig.EnvironmentFile =
    config.sops.secrets.acme.path;

  sops.secrets.acme = {
    sopsFile = acmeEnv;
    format = "dotenv";
  };

  environment.persistence."${config.hostSpec.persistFolder}".directories = lib.mkIf isImpermanent [
      "/var/lib/acme"
    ];

}
