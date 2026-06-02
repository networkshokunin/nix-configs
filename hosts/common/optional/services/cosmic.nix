{
  pkgs, config, ...
}:
{
  #reference: https://wiki.nixos.org/wiki/COSMIC
  
  # Enable the COSMIC login manager
  services.displayManager.cosmic-greeter.enable = true;

  # Enable the COSMIC desktop environment
  services.desktopManager.cosmic.enable = true;

  # Caps Lock -> Super remap lives in home/oscar/common/optional/desktops/cosmic.nix
  # (cosmic-comp ignores services.xserver.xkb.options).

  environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;

  #services.displayManager.autoLogin = {
  #  enable = true;
  #  user = "${config.hostSpec.username}";
  #};

  environment.cosmic.excludePackages = with pkgs; [
    cosmic-edit
    cosmic-term
  ];

  services.system76-scheduler.enable = true;
}
