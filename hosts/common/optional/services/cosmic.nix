{
  pkgs, config, ...
}:
{
  #reference: https://wiki.nixos.org/wiki/COSMIC
  
  # Enable the COSMIC login manager
  services.displayManager.cosmic-greeter.enable = true;

  # Enable the COSMIC desktop environment
  services.desktopManager.cosmic.enable = true;

  #services.displayManager.autoLogin = {
  #  enable = true;
  #  user = "${config.hostSpec.username}";
  #};

  environment.cosmic.excludePackages = with pkgs; [
    cosmic-edit
    cosmic-term
  ];
}
