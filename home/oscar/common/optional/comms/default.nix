# FIXME(starter): add/edit any optional, communications related pkgs here
{ pkgs, ... }:
{
  #imports = [ ./foo.nix ];

  home.packages = builtins.attrValues {
    inherit (pkgs)
      signal-desktop
      whatsapp-electron
      ;
  };
}
