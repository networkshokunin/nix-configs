{ pkgs, ... }: 
let
  isImpermanent = config.system ? "impermanence" && config.system.impermanence.enable;
in
{

  #reference: https://wiki.nixos.org/wiki/Fingerprint_scanner
  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;
  security.pam.services.login.fprintAuth = true;
  security.pam.services.sudo.fprintAuth = true;

  environment.persistence."${config.hostSpec.persistFolder}".directories = lib.mkIf isImpermanent [
      "/var/lib/fprint"
    ];
}