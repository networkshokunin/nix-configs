{ lib, config, ... }:
let
  isImpermanent = config.system ? "impermanence" && config.system.impermanence.enable;

  # ── Instance definitions ──────────────────────────────────────────────────────
  # Each dataDir should contain your existing configuration.yaml, coordinator_backup.json,
  # database.db, and state.json — copied from your old /config/zigbee2mqtt_* directories.
  instances = [
    { name = "z2m-1"; }
    { name = "z2m-2"; }
    { name = "z2m-3"; }
    { name = "z2m-4"; }
    { name = "z2m-5"; }
    { name = "z2m-6"; }
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

in
{
  # ── OCI containers ────────────────────────────────────────────────────────────
  virtualisation.oci-containers.containers =
    lib.listToAttrs (map (inst: {
      name  = inst.name;
      value = mkContainer inst;
    }) instances);

  networking.firewall = {
    allowedTCPPortRanges = [{ from = 8881; to = 8886; }];
  };

  systemd.tmpfiles.rules = map (inst: 
      "d /var/lib/zigbee2mqtt/${inst.name} 0755 root root -"
    ) instances;

  # ── Impermanence ─────────────────────────────────────────────────────────────
  environment.persistence."${config.hostSpec.persistFolder}".directories =
    lib.mkIf isImpermanent
      (map (inst: "/var/lib/zigbee2mqtt/${inst.name}") instances);
}
