{ config, pkgs, ... }:
let 
  isImpermanent = config.system ? "impermanence" && config.system.impermanence.enable;
  nix-var-acmePath = "${inputs.nix-secrets}/nix-vars/acme.nix";
  acmeConfig = import "${nix-var-acmePath}";
in 
{
  virtualisation.oci-containers.containers.scrypted = {
      image = "ghcr.io/koush/scrypted";
      # Alternatives:
      #   ghcr.io/koush/scrypted:lite     (no GStreamer, smaller)

      autoStart = true;
      extraOptions = [
        "--network=host"  # Required for HomeKit/mDNS discovery

        # Uncomment to pass through hardware devices:
        # "--device=/dev/dri:/dev/dri"         # Intel iGPU / hardware decode
        # "--device=/dev/kfd:/dev/kfd"         # AMD GPU
        # "--device=/dev/bus/usb:/dev/bus/usb" # USB devices (Coral TPU, Z-Wave, etc.)
      ];

      volumes = [
        "/var/lib/scrypted:/server/volume"
        # Uncomment to use host Avahi for mDNS (instead of in-container daemon):
        # "/var/run/dbus:/var/run/dbus"
        # "/var/run/avahi-daemon/socket:/var/run/avahi-daemon/socket"
      ];

      environment = {
        TZ = "Asia/Singapore";
        # Uncomment to run avahi inside the container
        # (don't combine with host socket mounts above):
        # SCRYPTED_DOCKER_AVAHI = "true";
      };

      # Create the data directory
      systemd.tmpfiles.rules = [
        "d /var/lib/scrypted 0750 root root -"
      ];

      networking.firewall.allowedTCPPorts = [ 10443 ];
  };

  services.nginx.virtualHosts."scrypted.${acmeConfig.domain}" = {
    forceSSL = true;
    useACMEHost = "${acmeConfig.domain}";
    locations."/" = {
      proxyPass = "https://127.0.0.1:10443";
      # extraConfig = ''
      #   proxy_ssl_verify off;
      #   proxy_set_header Host $host;
      #   proxy_set_header Upgrade $http_upgrade;
      #   proxy_set_header Connection "upgrade";
  
      #   # Uncomment to restrict access:
      #   # allow ${mgt_network}/${toString mgt_network_prefix};
      #   # allow ${mgmt_wireguard_network}/${toString mgmt_wireguard_network_prefix};
      #   # allow 127.0.0.1;
      #   # deny all;
      '';
    };
  };

  environment.persistence."${config.hostSpec.persistFolder}".directories = lib.mkIf isImpermanent [
      "/var/lib/scrypted"
    ];    
}