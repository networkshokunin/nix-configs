# Core functionality for every nixos host
{ config, lib, ... }:
{
  # Database for aiding terminal-based programs
  environment.enableAllTerminfo = true;
  # Enable firmware with a license allowing redistribution
  hardware.enableRedistributableFirmware = true;

  # This should be handled by config.security.pam.sshAgentAuth.enable
  security.sudo.extraConfig = ''
    Defaults lecture = never # rollback results in sudo lectures after each reboot, it's somewhat useless anyway
    Defaults pwfeedback # password input feedback - makes typed password visible as asterisks
    Defaults timestamp_timeout=120 # only ask for password every 2h
    # Keep SSH_AUTH_SOCK so that pam_ssh_agent_auth.so can do its magic.
    Defaults env_keep+=SSH_AUTH_SOCK
  '';

  #
  # ========== Nix Helper ==========
  #
  # Provide better build output and will also handle garbage collection in place of standard nix gc (garbace collection)
  # FIXME(starter): customize garbage collection rules as desired.
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 14d --keep 10";
    # FIXME(starter): `config.hostSpec.home` will be `/home/foo/`, or `/Users/foo/` if you are on Darwin. Edit the rest of the path
    # so that it leads to where you store your nix-config.  e.g. if you have your config at `/home/foo/src/nix/nix-config` then the following
    # would be `flake = "${config.hostSpec.home}/src/nixnix-config";`
    flake = "${config.hostSpec.home}/nix-config";
  };

  #
  # ========== Localization ==========
  #

  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
  time.timeZone = lib.mkDefault "Asia/Singapore";
}
