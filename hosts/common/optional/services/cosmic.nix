{
  pkgs, config, ...
}:
{
  # Enable the COSMIC login manager
  services.displayManager.cosmic-greeter.enable = true;

  # Enable the COSMIC desktop environment
  services.desktopManager.cosmic.enable = true;

  services.displayManager.autoLogin = {
    enable = true;
    # Replace `yourUserName` with the actual username of user who should be automatically logged in
    user = "${config.hostSpec.username}";
  };

  environment.cosmic.excludePackages = with pkgs; [
    cosmic-edit
    cosmic-term
  ];
}
