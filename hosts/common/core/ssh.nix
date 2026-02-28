{
  lib,
  pkgs,
  ...
}:
{
  programs.ssh = lib.optionalAttrs pkgs.stdenv.isLinux {
    startAgent = true;
    enableAskPassword = true;
 };
}
