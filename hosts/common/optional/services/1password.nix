{
  config,
  ...
}:
{
  #reference: https://wiki.nixos.org/wiki/1Password
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "${config.hostSpec.username}" ];
  };

  environment.etc = {
        "1password/custom_allowed_browsers" = {
          text = ''
            vivaldi-bin
          '';
          mode = "0755";
        };
        "xdg/autostart/1password.desktop" = {
          text = ''
            [Desktop Entry]
            Name=1Password
            Exec=1password --silent
            Terminal=false
            Type=Application
            Icon=1password
            StartupWMClass=1Password
            X-GNOME-Autostart-enabled=true
          '';
          mode = "0644";
        };
      };

}