{ pkgs, ... }:
{
  home.packages = builtins.attrValues {
    inherit (pkgs)
      unstable.code-cursor
      ;
  };
}
