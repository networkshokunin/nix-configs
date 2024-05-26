{
  services.chrony = {
    enable = true;
    servers = ["ntpmon.dcs1.biz" "time.cloudflare.com"];
    #https://github.com/jauderho/nts-servers
    serverOption = "iburst";
    #https://wiki.archlinux.org/title/Chrony
    enableNTS = true;
    extraConfig = ''
      allow 10.168.0.0/20
      '';
    }; 
  networking.firewall.allowedUDPPorts = [ 123 ];
  #todo: dhcpcd hook
}