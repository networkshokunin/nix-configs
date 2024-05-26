{ myvars, ... }:
{
  services.adguardhome = {
    enable = true;
    host = "0.0.0.0";
    port = 8001;
    mutableSettings = true;
    allowDHCP = false;
    #sudo cat /var/lib/AdGuardHome/AdGuardHome.yaml
    settings = {
      dns = {
        bind_hosts = [
          "0.0.0.0"
        ];
        port = 53;
        anonymize_client_ip= false;
        allowed_clients = [
          "127.0.0.1"
          "10.168.0.0/20"
        ];
        ratelimit = 60;
        upstream_dns = [
          "127.0.0.1:5353"
        ];
        fallback_dns = [
          "1.1.1.1"
        ];
        dhcp.enabled = false;
        use_private_ptr_resolvers = true;
        local_ptr_upstreams = [
          "127.0.0.1:5353"
        ];
      };
      statistics = {
        enabled = true;
        interval = "720h";
      };
      filters = [
        {
          enabled = false;
          name = "AdGuard DNS filter";
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt";
          id = 1;
        }
        {
          enabled = false;
          name = "AdAway Default Blocklist";
          url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_2.txt";
          id = 2;
        }          
        {
          enabled = true;
          name = "OISD (Big)";
          url = "https://big.oisd.nl";
          id = 3;
        }
      ];
    };
  };


  services.nginx.virtualHosts."adguard.${myvars.domain}" = {
    forceSSL = true;
    useACMEHost = "adguard.${myvars.domain}";
    locations."/".proxyPass = "http://localhost:8001";
	  extraConfig = ''
		  proxy_set_header Host $host;
	  '';
  };

  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
}
