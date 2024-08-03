{
  lib,
  mylib,
  myvars,
  ...
}: {
  home.homeDirectory = lib.mkForce "/Users/${myvars.osx_username}";
  imports =
    (mylib.scanPaths ./.)
    ++ [
      ../base/core
      ../base/tui
      ../base/gui
      ../base/home.nix
    ];
}
