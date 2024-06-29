{ pkgs, myvars, ... }:
{
  services.unifi.enable = true;
  services.unifi.unifiPackage = pkgs.unifi8;

  services.nginx.virtualHosts."unifi.${myvars.domain}" = {
    forceSSL = true;
    useACMEHost = "${myvars.domain}";
    locations."/".proxyPass = "https://localhost:8443";
	  extraConfig = ''
      proxy_buffering off;
		  proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forward-For $proxy_add_x_forwarded_for;
      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection "Upgrade";
	  '';
  };

  networking.firewall = {
    allowedTCPPorts = [ 
                        8080  # Port for UAP to inform controller.
                        #8880 # Port for HTTP portal redirect, if guest portal is enabled.
                        8843  # Port for HTTPS portal redirect, ditto.
                        #6789 # Port for UniFi mobile speed test.
                      ];
    allowedUDPPorts = [
                        3478  # UDP port used for STUN.
                        10001 # UDP port used for device discovery.
                      ];
  };
}