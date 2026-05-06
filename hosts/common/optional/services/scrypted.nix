{ lib, inputs, config, ... }:
let
  isImpermanent = config.system ? "impermanence" && config.system.impermanence.enable;
  nix-var-acmePath = "${inputs.nix-secrets}/nix-vars/acme.nix";
  acmeConfig = import "${nix-var-acmePath}";

  nix-var-networkPath = "${inputs.nix-secrets}/nix-vars/network.nix";
  netConfig = (import nix-var-networkPath { inherit lib; }) { 
      hostname = config.hostSpec.hostName; 
    };
  users_network = netConfig.subnetProfiles.users.network;
  users_network_prefix = netConfig.subnetProfiles.users.prefixLength;

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
      SCRYPTED_DOCKER_AVAHI = "true";
    };
  };                                          # <-- container block ends here

  systemd.tmpfiles.rules = [
    "d /var/lib/scrypted 0750 root root -"
  ];

  networking.firewall = {
    allowedUDPPorts = [ 5353 ];
    extraCommands = ''
      # HomeKit controller
      iptables -A nixos-fw -p tcp --dport 58881:58810 -s $users_network/${toString users_network_prefix} -j nixos-fw-accept
    '';
    extraStopCommands = ''
      iptables -D nixos-fw -p tcp --dport 58881:58810 -s $users_network/${toString users_network_prefix} -j nixos-fw-accept || true
    '';
  };

  services.nginx.virtualHosts."scrypted.${acmeConfig.domain}" = {
    forceSSL = true;
    useACMEHost = acmeConfig.domain;
    locations."/" = {
      proxyPass = "http://127.0.0.1:11080";
      proxyWebsockets = true; # NixOS helper that sets Upgrade/Connection headers
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        client_max_body_size 0; # Needed for plugin uploads/backups
      '';
};
  };

  environment.persistence."${config.hostSpec.persistFolder}".directories =
    lib.mkIf isImpermanent [
      "/var/lib/scrypted"
    ];
}