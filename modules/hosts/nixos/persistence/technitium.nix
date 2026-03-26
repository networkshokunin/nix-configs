{
  config,
  lib,
  ...
}:
let
  isImpermanent = config.system ? "impermanence" && config.system.impermanence.enable;
in
{
  config = lib.mkIf (config.services.technitium-dns-server.enable && isImpermanent) {
    environment.persistence."${config.hostSpec.persistFolder}".directories = [
      "/var/lib/private/technitium-dns-server"
    ];
  };
}