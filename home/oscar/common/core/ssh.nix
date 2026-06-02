{
  config,
  lib,
  ...
}:
let
  onePassPath = "~/.1password/agent.sock";
in    
{
  programs.ssh =
   {
      enable = true;
      enableDefaultConfig = false;
      extraConfig = lib.mkIf config.hostSpec.use1password ''
        Host *
            IdentityAgent ${onePassPath}
      '';
      settings = {
         "*" = {
            ControlMaster = "auto";
            ControlPath = "${config.home.homeDirectory}/.ssh/sockets/S.%r@%h:%p";
            ControlPersist = "20m";
            # Avoids infinite hang if control socket connection interrupted. ex: vpn goes down/up
            ServerAliveCountMax = 3;
            ServerAliveInterval = 5; # 3 * 5s
            HashKnownHosts = true;
            AddKeysToAgent = "yes";
         };
      };
    };
  home.file = {
    ".ssh/config.d/.keep".text = "# Managed by Home Manager";
    ".ssh/sockets/.keep".text = "# Managed by Home Manager";
  };
}
