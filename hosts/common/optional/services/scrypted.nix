{ lib, inputs, config, ... }:
let
  isImpermanent = config.system ? "impermanence" && config.system.impermanence.enable;
  nix-var-acmePath = "${inputs.nix-secrets}/nix-vars/acme.nix";
  acmeConfig = import "${nix-var-acmePath}";
in
{
  virtualisation.oci-containers.containers.scrypted = {
    image = "ghcr.io/koush/scrypted";
    # Alternatives:
    #   ghcr.io/koush/scrypted:lite  (no GStreamer, smaller)
    autoStart = true;
    extraOptions = [
      "--network=host"  # Required for HomeKit/mDNS discovery
      # "--device=/dev/dri:/dev/dri"
      # "--device=/dev/kfd:/dev/kfd"
      # "--device=/dev/bus/usb:/dev/bus/usb"
    ];
    volumes = [
      "/var/lib/scrypted:/server/volume"
      # "/var/run/dbus:/var/run/dbus"
      # "/var/run/avahi-daemon/socket:/var/run/avahi-daemon/socket"
    ];
    environment = {
      TZ = "Asia/Singapore";
      # SCRYPTED_DOCKER_AVAHI = "true";
    };
  };                                          # <-- container block ends here

  systemd.tmpfiles.rules = [
    "d /var/lib/scrypted 0750 root root -"
  ];

  networking.firewall.allowedTCPPorts = [ 11080 ];

  services.nginx.virtualHosts."scrypted.${acmeConfig.domain}" = {
    forceSSL = true;
    useACMEHost = acmeConfig.domain;
    locations."/" = {
      proxyPass = "http://127.0.0.1:11080";
      # extraConfig = ''
      #   proxy_ssl_verify off;
      #   proxy_set_header Host $host;
      #   proxy_set_header Upgrade $http_upgrade;
      #   proxy_set_header Connection "upgrade";
      # '';
    };
  };

  environment.persistence."${config.hostSpec.persistFolder}".directories =
    lib.mkIf isImpermanent [
      "/var/lib/scrypted"
    ];
}