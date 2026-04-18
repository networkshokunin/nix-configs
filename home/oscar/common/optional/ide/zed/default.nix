{ pkgs, inputs, ... }:
{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "nil"
      "toml"
      "catppuccin"
      "catppuccin-icons"
    ];
    userSettings = {
      theme = {
        mode = "system";
        dark = "Catppuccin Mocha";
        light = "Catppuccin Mocha";
      };
      hour_format = "hour24";
      #vim_mode = true;
    };
    extraPackages = with pkgs; [
      nixd
      nil # nix language server
    ];
  };

  # home.packages = builtins.attrValues {
  #   inherit (pkgs.unstable)
  #     nixd
  #     nil
  #     ;
  # };
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
}
