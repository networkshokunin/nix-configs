{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.zsh.enable = true;
  
  environment.variables = {
    # fix https://github.com/NixOS/nixpkgs/issues/238025
    TZ = "${config.time.timeZone}";
  };
}