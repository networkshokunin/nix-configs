# FIXME(starter): modify this file and the other .nix files in `nix-config/hosts/common/core/` to declare
# settings that will occur across all hosts

# IMPORTANT: This is used by NixOS and nix-darwin so options must exist in both!
{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  isDarwin,
  ...
}:
let
  platform = if isDarwin then "darwin" else "nixos";
  platformModules = "${platform}Modules";
in
{
  imports = lib.flatten [
    inputs.home-manager.${platformModules}.home-manager
    inputs.sops-nix.${platformModules}.sops

    (map lib.custom.relativeToRoot [
      "modules/common"
      "modules/hosts/common"
      "modules/hosts/${platform}"
      "hosts/common/core/${platform}.nix"
      "hosts/common/core/sops.nix" # 
      #"hosts/common/core/ssh.nix"
      "hosts/common/core/services" # uncomment this line if you add any modules to services directory
      "hosts/common/users/primary"
      "hosts/common/users/primary/${platform}.nix"
    ])
  ];

  #
  # ========== Core Host Specifications ==========
  #
  # FIXME(starter): modify the hostSpec options below to define values that are common across all hosts
  # such as the username and handle of the primary user (see also `nix-config/hosts/common/users/primary`)
  hostSpec = {
    username = "oscar";
    # handle = "oscar";
    inherit (inputs.nix-secrets)
      domain
      email
      gitSigningKey
      userFullName
      # networking 
      ;
  };

  networking.hostName = config.hostSpec.hostName;

  # System-wide packages, in case we log in as root
  environment.systemPackages = [ pkgs.openssh ];

  # Force home-manager to use global packages
  home-manager.useGlobalPkgs = true;

  # If there is a conflict file that is backed up, use this extension
  home-manager.backupFileExtension = "bk";

  #
  # ========== Overlays ==========
  #
  nixpkgs = {
    overlays = [
      outputs.overlays.default
    ];
    config = {
      allowUnfree = true;
    };
  };

  #
  # ========== Nix Nix Nix ==========
  #
  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # See https://jackson.dev/post/nix-reasonable-defaults/
      connect-timeout = 5;
      log-lines = 25;
      min-free = 128000000; # 128MB
      max-free = 1000000000; # 1GB

      trusted-users = [ "@wheel" ];
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
      warn-dirty = false;

      allow-import-from-derivation = true;

      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
}
