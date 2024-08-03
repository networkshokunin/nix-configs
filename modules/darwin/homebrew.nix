
{config, lib, pkgs, ... }:
{
  homebrew = {
    enable = true; # disable homebrew for fast deploy

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    # Applications to install from Mac App Store using mas.

    masApps = {
      PurePaste = 1611378436;
      Dato = 1470584107;
      Things3 = 904280696;
      Wireguard = 1451685025;
      WirelessSGx = 1449928544;
      CommandX = 6448461551;
      SinkItForReddit = 6449873635;
    };

    taps = [
      "homebrew/services"
    ];

    brews = [
      # `brew install`
      "wget" 
      "curl" # no not install curl via nixpkgs, it's not working well on macOS!
      "aria2"
      #"wireguard-tools" # wireguard
      "goenv"
      "php"

      # Usage:
      #  https://github.com/tailscale/tailscale/wiki/Tailscaled-on-macOS#run-the-tailscaled-daemon
      # 1. `sudo tailscaled install-system-daemon`
      # 2. `tailscale up --accept-routes`
      #"tailscale" # tailscale

      # commands like `gsed` `gtar` are required by some tools
      "gnu-sed"
      "gnu-tar"

      # misc that nix do not have cache for.
      "git-trim"
    ];

    # `brew install --cask`
    casks = [
      "raindropio"  
      "whatsapp"
      "visual-studio-code"
      "1password"
      "1password-cli"
      "alfred"
      "signal"
      "setapp"
      "showmeyourhotkeys"
      "thingsmacsandboxhelper"
      "keyboardcleantool"
      "appcleaner"
      "karabiner-elements"
      "obsidian"
      "firefox"
      "cleanclip"
      "openinterminal"
      "ledger-live"
      "topnotch"
      "elgato-stream-deck"
    ];
  };
}