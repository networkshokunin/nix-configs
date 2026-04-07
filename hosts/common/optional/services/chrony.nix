{ config,inputs, ...}:
let
  nix-var-networkPath = "${inputs.nix-secrets}/nix-vars/network.nix";
  netConfig = (import nix-var-networkPath { inherit lib; }) { 
      hostname = config.hostSpec.hostName; 
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
      allow ${netConfig.network}/${toString netConfig.prefixLength}
      '';
    }; 
  networking.firewall.allowedUDPPorts = [ 123 323 ];

  environment.persistence."${config.hostSpec.persistFolder}".directories = [
      "/var/lib/chrony"
    ];
}