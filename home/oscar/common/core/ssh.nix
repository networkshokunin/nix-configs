{
  config,
  ...
}:
{
  programs.ssh =
   {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
         "*" = {
            controlMaster = "auto";
            controlPath = "${config.home.homeDirectory}/.ssh/sockets/S.%r@%h:%p";
            controlPersist = "20m";
            # Avoids infinite hang if control socket connection interrupted. ex: vpn goes down/up
            serverAliveCountMax = 3;
            serverAliveInterval = 5; # 3 * 5s
            hashKnownHosts = true;
            addKeysToAgent = "yes";
         };
      };
    };
  home.file = {
    ".ssh/config.d/.keep".text = "# Managed by Home Manager";
    ".ssh/sockets/.keep".text = "# Managed by Home Manager";
  };
}
