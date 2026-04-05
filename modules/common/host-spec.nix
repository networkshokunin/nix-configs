# Specifications For Differentiating Hosts
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  nix-var-userPath = "${inputs.nix-secrets}/nix-vars/user.nix";
  userConfig = import "${nix-var-userPath}";
in
{
  options.hostSpec = lib.mkOption {
    type = lib.types.submodule {
      freeformType = with lib.types; attrsOf str;

      options = {
        # Data variables that don't dictate configuration settings
        primaryUsername = lib.mkOption {
          type = lib.types.str;
          default = userConfig.username;
          description = "The primary administrative username of the host";
        };
        primaryDesktopUsername = lib.mkOption {
          type = lib.types.str;
          description = "The primary desktop user on the host";
          default = config.hostSpec.primaryUsername;
        };
        # FIXME: deprecated. Use either primaryUsername or map over users
        username = lib.mkOption {
          type = lib.types.str;
          description = "The username of the host";
        };
        hostName = lib.mkOption {
          type = lib.types.str;
          description = "The hostname of the host";
        };
        email = lib.mkOption {
          description = "Email configuration for the user";
          type = lib.types.submodule {
            options = {
              user = lib.mkOption {
                type = lib.types.str;
                default = userConfig.email.user;
                description = "Primary email address.";
              };
              git = lib.mkOption {
                type = lib.types.str;
                default = userConfig.email.git;
                description = "Email address used for Git commits.";
              };
            };
          };
        };
        work = lib.mkOption {
          default = { };
          type = lib.types.attrsOf lib.types.anything;
          description = "An attribute set of work-related information if isWork is true";
        };
        networking = lib.mkOption {
          default = { };
          type = lib.types.attrsOf lib.types.anything;
          description = "An attribute set of networking information";
        };
        wifi = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Used to indicate if a host has wifi";
        };
        domain = lib.mkOption {
          type = lib.types.str;
          default = userConfig.domain; # Need a default for the installer
          description = "Domain of the host";
        };
        userFullName = lib.mkOption {
          type = lib.types.str;
          default = userConfig.userFullName;
          description = "Full name of the user";
        };
        gitSigningKey = lib.mkOption {
          type = lib.types.str;
          default = userConfig.gitSigningKey;
          description = "GPG signing key for git commits";
        };
        handle = lib.mkOption {
          type = lib.types.str;
          description = "The handle of the user (eg: github user)";
        };
        # FIXME: This isn't great for multi-user systems
        home = lib.mkOption {
          type = lib.types.str;
          description = "The home directory of the user";
          default =
            let
              user = config.hostSpec.primaryUsername;
            in
            if pkgs.stdenv.isLinux then "/home/${user}" else "/Users/${user}";
        };
        persistFolder = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "The folder to persist data if impermenance is enabled";
          default = null;
        };

        impermanenceDirectories = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = "A list of directories to persist if impermanence is enabled";
          default = [ ];
        };

        # Configuration Settings
        users = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = "An attribute set of all users on the host";
          default = [ config.hostSpec.primaryUsername ];
        };
        isMinimal = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Indicate a minimal host";
        };
        isImpermanent = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Indicate a host uses impermanence";
        };
        isServer = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Indicate a server host";
        };
        isLocal = lib.mkOption {
          type = lib.types.bool;
          default = (!config.hostSpec.isRemote);
          description = "Used to indicate a host that is remotely managed";
        };
        isAdmin = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Used to indicate a host that is used to admin other systems";
        };
        theme = lib.mkOption {
          type = lib.types.str;
          default = "dracula";
          description = "The theme to use for the host (stylix, vscode, neovim, etc)";
        };
        wallpaper = lib.mkOption {
          type = lib.types.path;
          default = "${inputs.nix-assets}/images/wallpapers/zen-01.png";
          description = "Path to wallpaper to use for system";
        };
        defaultBrowser = lib.mkOption {
          type = lib.types.str;
          default = "firefox";
          description = "The default browser to use on the host";
        };
        defaultEditor = lib.mkOption {
          type = lib.types.str;
          default = "nvim";
          description = "The default editor command to use on the host";
        };
        defaultMediaPlayer = lib.mkOption {
          type = lib.types.str;
          default = "vlc";
          description = "The default video player to use on the host";
        };
        defaultDesktop = lib.mkOption {
          type = lib.types.str;
          default = "niri";
          description = "The default desktop environment to use on the host";
        };
        use1password = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Indicate if the host uses 1Password";
        };
        # This is needed because nix.nix uses timeZone in both nixos and home context, the latter of which doesnt' have access to time.timeZone
        timeZone = lib.mkOption {
          type = lib.types.str;
          default = "Asia/Singapore";
          description = "Timezone the system is in";
        };

      };
    };
  };

  config = {
    # FIXME: Add an assertion that the wifi category has a corresponding wifi.<cat>.yaml file in nix-secerts/sops/
    assertions =
      let
        # We import these options to HM and NixOS, so need to not fail on HM
        isImpermanent =
          config ? "system" && config.system ? "impermanence" && config.system.impermanence.enable;
      in
      [
        {
          assertion = !isImpermanent || (isImpermanent && ("${config.hostSpec.persistFolder}" != ""));
          message = "config.system.impermanence.enable is true but no persistFolder path is provided";
        }
        {
          assertion = lib.elem config.hostSpec.primaryUsername config.hostSpec.users;
          message = "primaryUsername doesn't exist in list of users";
        }
      ];
  };
}