#FIXME: Move attrs that will only work on linux to nixos.nix
{
  config,
  lib,
  pkgs,
  hostSpec,
  ...
}:
let
  platform = if pkgs.stdenv.isDarwin then "darwin" else "nixos";
  #platform = if hostSpec.isDarwin then "darwin" else "nixos";
in
{
  imports = lib.flatten [
    (map lib.custom.relativeToRoot [
      "modules/common/host-spec.nix"
      "modules/home"
    ])
    ./${platform}.nix

    ./bash.nix
    ./direnv.nix
    ./fonts.nix
    ./git.nix
    ./nixos.nix
    ./ssh.nix
  ];

  inherit hostSpec;

  services.ssh-agent.enable = true;

  home = {
    username = lib.mkDefault config.hostSpec.username;
    homeDirectory = lib.mkDefault config.hostSpec.home;
    stateVersion = lib.mkDefault "25.11";
    sessionPath = [
      "$HOME/.local/bin"
    ];
    sessionVariables = {
      FLAKE = "$HOME/src/nix/nix-config";
      SHELL = "bash";
    };
  };

  home.packages = builtins.attrValues {
    inherit (pkgs)

      # Packages that don't have custom configs go here
      curl
      pciutils
      pfetch # system info
      pre-commit # git hooks
      p7zip # compression & encryption
      usbutils
      unzip # zip extraction
      unrar # rar extraction
      xz
      zstd
      dnsutils
      iperf3
      wget
      vim
      fzf
      zoxide # zoxide is a smarter cd replacement that learns your habits and makes it easier to navigate to frequently used directories. It integrates with the shell and can be used as a drop-in replacement for the traditional cd command, providing features like fuzzy searching and ranking of directories based on usage. By using zoxide, you can save time and keystrokes when navigating your filesystem, especially if you have a large number of directories or frequently access certain locations.
      ;
  };

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
    };
  };

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
