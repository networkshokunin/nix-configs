{ pkgs, ... }: 
{
  imports = [
    ./dock
  ];

  # Fully declarative dock using the latest from Nix Store
  local = {
    dock.enable = true;
    dock.entries = [
      {path = "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app";}
      {path = "/System/Applications/Mail.app";}
      {path = "/System/Applications/Calendar.app";}
      {path = "${pkgs.kitty}/Applications/kitty.app";}
      {path = "/Applications/Signal.app/";}
      {path = "/Applications/WhatsApp.app";}
      {path = "/System/Applications/Messages.app";}
      {path = "/Applications/Things3.app";} 
      {path = "/Applications/Raindrop.io.app";}
      # https://github.com/kcrawford/dockutil/issues/144
      {path = "/Applications/App Store.app";}
      {path = "/Applications/System Settings.app";}
    ];
  };
}
