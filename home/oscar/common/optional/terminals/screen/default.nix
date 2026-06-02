{ pkgs, ... }:
{
  home.packages = builtins.attrValues {
    inherit (pkgs)
      screen
      ;
  };

  home.file.".screenrc".text = ''
    escape ^Bb
  '';
}