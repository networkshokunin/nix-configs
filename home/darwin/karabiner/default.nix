{ ... }:
{
  home.file.karabiner = {
    source = ./karabiner.json;
    target = ".config/karabiner/karabiner.json";
    onChange = ''
      launchctl stop org.pqrs.karabiner.karabiner_console_user_server
      launchctl start org.pqrs.karabiner.karabiner_console_user_server
    '';
  };
}
