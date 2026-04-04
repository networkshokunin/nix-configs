{ pkgs, ... }:
{
  home.packages = builtins.attrValues {
    inherit (pkgs)
      code-cursor
      ;
  };
}