{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Install packages from nix's official package repository.
  #
  # The packages installed here are available to all users, and are reproducible across machines, and are rollbackable.
  # But on macOS, it's less stable than homebrew.
  #
  # Related Discussion: https://discourse.nixos.org/t/darwin-again/29331
  environment.systemPackages = with pkgs; [
    git
    #nushell # my custom shell
    gnugrep # replace macos's grep
    gnutar # replace macos's tar
    rectangle
    pyenv

  ];
  environment.variables =
    {
      # Fix https://github.com/LnL7/nix-darwin/wiki/Terminfo-issues
      TERMINFO_DIRS = map (path: path + "/share/terminfo") config.environment.profiles ++ ["/usr/share/terminfo"];

      EDITOR = "nvim";
    };
}
