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
    labels = {
      "io.containers.autoupdate" = "registry";
    };
    extraOptions = [
      "--network=host"  # Required for HomeKit/mDNS discovery
      # "--device=/dev/dri/renderD128"  # GPU passthrough - only if host has GPU
      # "--device=/dev/dri/card0"
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

  # networking.firewall.allowedTCPPorts = [ 11080 ];
  networking.firewall = {
    allowedTCPPortRanges = [{ from = 58881; to = 58891; }];
    allowedUDPPorts = [ 5353 ];
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

  users.users.scrypted = {
    isSystemUser = true;
    group = "scrypted";
    extraGroups = [ "video" "render" ];
  };
  
  users.groups.scrypted = {};
  users.groups.render = {};
  users.groups.video = {};
}