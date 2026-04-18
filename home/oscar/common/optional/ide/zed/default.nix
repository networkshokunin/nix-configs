{ pkgs, inputs, ... }:
{
    programs.zed-editor = {
      enable = true;
      extensions = [ "nix" "toml" ];
      userSettings = {
        theme = {
          mode = "system";
          dark = "One Dark";
          light = "One Light";
        };
        hour_format = "hour24";
        #vim_mode = true;
      };
    };
  #nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
}
