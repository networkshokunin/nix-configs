{ pkgs, inputs, ... }:
{
  home.packages = builtins.attrValues {
    inherit (pkgs.unstable)
      code-cursor
      nixd
      ;
  };
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
}
