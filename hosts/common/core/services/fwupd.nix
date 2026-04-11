{ config, lib, ... }: 
let
  isImpermanent = config.system ? "impermanence" && config.system.impermanence.enable;
in
{
  services.fwupd.enable = true;

  environment.persistence."${config.hostSpec.persistFolder}".directories = lib.mkIf isImpermanent [
      "/var/lib/fwupd"
      "/var/cache/fwupd"
    ];
}