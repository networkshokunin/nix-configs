{ inputs, ...}:
let
  nix-var-networkPath = "${inputs.nix-secrets}/nix-vars/network.nix";
  netConfig = import "${nix-var-networkPath}" { 
    hostname = "lan_supernet"; 
  };
in
{
  services.chrony = {
    enable = true;
    servers = ["ntpmon.dcs1.biz" "time.cloudflare.com"];
    #https://github.com/jauderho/nts-servers
    serverOption = "iburst";
    #https://wiki.archlinux.org/title/Chrony
    enableNTS = true;
    extraConfig = ''
      allow ${netConfig.network}/${netConfig.prefixLength}
      '';
    }; 
  networking.firewall.allowedUDPPorts = [ 123 323 ];

}