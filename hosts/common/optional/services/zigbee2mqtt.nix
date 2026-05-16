{ inputs, lib, config, ... }:
let
  isImpermanent = config.system ? "impermanence" && config.system.impermanence.enable;
  nix-var-acmePath = "${inputs.nix-secrets}/nix-vars/acme.nix";
  acmeConfig = import "${nix-var-acmePath}";

  # ── Instance definitions ──────────────────────────────────────────────────────
  # Each dataDir should contain your existing configuration.yaml, coordinator_backup.json,
  # database.db, and state.json — copied from your old /config/zigbee2mqtt_* directories.
  instances = [
    { name = "z2m-1"; port = 8881; }
    { name = "z2m-2"; port = 8882; }
    { name = "z2m-3"; port = 8883; }
    { name = "z2m-4"; port = 8884; }
    { name = "z2m-5"; port = 8885; }
    { name = "z2m-6"; port = 8886; }
  ];

  mkContainer = inst:
    let
      dataDir = "/var/lib/zigbee2mqtt/${inst.name}";
    in {
      image = "ghcr.io/koenkk/zigbee2mqtt:latest";

      volumes = [
        "${dataDir}:/app/data"
      ];

      extraOptions = [
        "--network=host"
      ];
    };

  mkZ2mVirtualHost = inst: {
      name = "${inst.name}.${acmeConfig.domain}"; # Generates z2m-1.yourdomain.com
      value = {
        forceSSL = true;
        useACMEHost = "${acmeConfig.domain}";
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString inst.port}";
          proxyWebsockets = true; # Necessary for the live Zigbee event streams
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;

            # Keeps uploads/backups from timing out over Nginx
            client_max_body_size 0;
            proxy_read_timeout 600s;
            proxy_send_timeout 600s;
          '';
        };
      };
    };

in
{
  # ── OCI containers ────────────────────────────────────────────────────────────
  virtualisation.oci-containers.containers =
    lib.listToAttrs (map (inst: {
      name  = inst.name;
      value = mkContainer inst;
    }) instances);

  virtualHosts = lib.listToAttrs (map mkZ2mVirtualHost instances);
  
  networking.firewall.allowedTCPPorts = [ 8881 8882 8883 8884 8885 8886 ];

  systemd.tmpfiles.rules = map (inst: 
      "d /var/lib/zigbee2mqtt/${inst.name} 0755 root root -"
    ) instances;

  # ── Impermanence ─────────────────────────────────────────────────────────────
  environment.persistence."${config.hostSpec.persistFolder}".directories =
    lib.mkIf isImpermanent
      (map (inst: "/var/lib/zigbee2mqtt/${inst.name}") instances);
}
