{
  lib,
  inputs,
  config,
  pkgs,
  ...
}:
let
  isImpermanent = config.system ? "impermanence" && config.system.impermanence.enable;
  sopsFolder = builtins.toString inputs.nix-secrets;
  nix-var-acmePath = "${inputs.nix-secrets}/nix-vars/acme.nix";
  acmeConfig = import "${nix-var-acmePath}";
  peanutPort = 8881;
in
{
  # ── Sops Secrets ────────────────────────────────────────────────────────────
  sops.secrets.community_string = {
    sopsFile = "${sopsFolder}/sops/nut.env";
    format = "dotenv";
    key = "community_string"; # <-- Set this key to your SNMPv2c Community String in your sops file
    owner = "root";
    mode = "0400";
  };

  sops.secrets.nut-upsmon-password = {
    sopsFile = "${sopsFolder}/sops/nut.env";
    format = "dotenv";
    key = "upsmonPassword";
    owner = "root";
    mode = "0400";
  };

  # ── Inject SNMP secrets into ups.conf before driver starts ──────────────────
  systemd.services.ups-inject-secrets = {
    description = "Inject UPS SNMP secrets into NUT configuration";
    wantedBy = [ "nut-driver-ups1.service" ];
    before = [ "nut-driver-ups1.service" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      AUTH=$(${pkgs.coreutils}/bin/cat ${config.sops.secrets.community_string.path})
      ${pkgs.gnused}/bin/sed -i "s|@AUTH_PASSWORD@|$AUTH|g" /etc/nut/ups.conf
    '';
  };

  # Also ensure driver waits for network (UPS is remote via SNMP)
  systemd.services.nut-driver-ups1 = {
    after = [
      "network-online.target"
      "ups-inject-secrets.service"
    ];
    wants = [ "network-online.target" ];
    requires = [ "ups-inject-secrets.service" ];
  };

  # ── NUT (Network UPS Tools) ─────────────────────────────────────────────────
  power.ups = {
    enable = true;
    mode = "netserver";

    ups.ups1 = {
      driver = "snmp-ups";
      port = "ups1.ib.${acmeConfig.domain}";
      description = "Eaton UPS";
      directives = [
        "mibs = pw"
        "snmp_version = v2c"
        "community = @AUTH_PASSWORD@" # Replaced at runtime by ups-inject-secrets
      ];
    };

    upsd = {
      enable = true;
      listen = [
        {
          address = "0.0.0.0";
          port = 3493;
        }
      ];
    };

    users.upsmon = {
      passwordFile = config.sops.secrets.nut-upsmon-password.path;
      upsmon = "primary";
      actions = [
        "set"
        "fsd"
      ];
      instcmds = [ "all" ];
    };

    upsmon = {
      enable = true;
      monitor.ups1 = {
        system = "ups1@localhost";
        user = "upsmon";
        type = "primary";
        powerValue = 1;
      };
    };
  };

  # ── Pre-configure PeaNUT with NUT connection ─────────────────────────────────
  environment.etc."peanut-settings.yml" = {
    text = ''
      NUT_SERVERS:
        - HOST: localhost
          PORT: 3493
          USERNAME: upsmon
          PASSWORD: @UPSMON_PASSWORD@
    '';
  };

  systemd.services.peanut-config = {
    description = "Configure PeaNUT settings with secrets";
    wantedBy = [ "podman-peanut.service" ];
    before = [ "podman-peanut.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      UPSMON_PASSWORD=$(${pkgs.coreutils}/bin/cat ${config.sops.secrets.nut-upsmon-password.path})
      ${pkgs.coreutils}/bin/mkdir -p /var/lib/peanut
      ${pkgs.coreutils}/bin/cp /etc/peanut-settings.yml /var/lib/peanut/settings.yml
      ${pkgs.gnused}/bin/sed -i "s|@UPSMON_PASSWORD@|$UPSMON_PASSWORD|g" /var/lib/peanut/settings.yml
      ${pkgs.coreutils}/bin/chmod 600 /var/lib/peanut/settings.yml
    '';
  };

  # ── PeaNUT dashboard (container) ────────────────────────────────────────────
  virtualisation.oci-containers.containers.peanut = {
    image = "brandawg93/peanut:latest";
    autoStart = true;
    extraOptions = [
      "--network=host" # allows container to reach localhost:3493 (NUT upsd)
    ];
    volumes = [
      "/var/lib/peanut:/config"
    ];
    environment = {
      TZ = "Asia/Singapore";
      WEB_HOST = "0.0.0.0";
      WEB_PORT = toString peanutPort;
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/peanut 0750 root root -"
  ];

  networking.firewall.allowedTCPPorts = [
    3493 # NUT upsd — for Home Assistant and other LAN clients
  ];

  # ── Nginx reverse proxy ─────────────────────────────────────────────────────
  services.nginx.virtualHosts."peanut.${acmeConfig.domain}" = {
    forceSSL = true;
    useACMEHost = acmeConfig.domain;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString peanutPort}";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
      '';
    };
  };

  # ── Persistence ─────────────────────────────────────────────────────────────
  environment.persistence."${config.hostSpec.persistFolder}".directories = lib.mkIf isImpermanent [
    "/var/lib/peanut"
    "/var/lib/nut"
  ];
}
