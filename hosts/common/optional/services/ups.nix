{
  lib,
  inputs,
  config,
  ...
}:
let
  isImpermanent = config.system ? "impermanence" && config.system.impermanence.enable;
  sopsFolder = builtins.toString inputs.nix-secrets;
  nix-var-acmePath = "${inputs.nix-secrets}/nix-vars/acme.nix";
  acmeConfig = import "${nix-var-acmePath}";

  nix-var-networkPath = "${inputs.nix-secrets}/nix-vars/network.nix";
  netConfig = (import nix-var-networkPath { inherit lib; }) {
    hostname = config.hostSpec.hostName;
  };
in
{
  # ── Sops Secrets ────────────────────────────────────────────────────────────
  sops.secrets.nut-auth-password = {
    sopsFile = "${sopsFolder}/sops/nut.env";
    format = "dotenv";
    key = "authPassword";
    owner = "root";
    mode = "0400";
  };

  sops.secrets.nut-priv-password = {
    sopsFile = "${sopsFolder}/sops/nut.env";
    format = "dotenv";
    key = "privPassword";
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

  # ── Assemble secretsDir file before NUT driver starts ───────────────────────
  systemd.services.nut-snmp-secrets = {
    description = "Assemble NUT SNMP secrets for ups1";
    before = [ "nut-driver-ups1.service" ];
    wantedBy = [ "nut-driver-ups1.service" ];
    serviceConfig.Type = "oneshot";
    script = ''
      mkdir -p /run/secrets/nut
      chmod 700 /run/secrets/nut
      printf 'authPassword = %s\nprivPassword = %s\n' \
        "$(cat ${config.sops.secrets.nut-auth-password.path})" \
        "$(cat ${config.sops.secrets.nut-priv-password.path})" \
        > /run/secrets/nut/ups1.conf
      chmod 400 /run/secrets/nut/ups1.conf
    '';
  };

  # ── NUT (Network UPS Tools) ─────────────────────────────────────────────────
  power.ups = {
    enable = true;
    mode = "netserver";
    secretsDir = "/run/secrets/nut";

    ups.ups1 = {
      driver = "snmp-ups";
      port = "ups1.ib.${acmeConfig.domain}";
      description = "Eaton UPS";
      directives = [
        "mibs = pw"
        "snmp_version = v3"
        "secLevel = authPriv"
        "secName = snmp_readonly"
        "authProtocol = SHA512"
        "privProtocol = AES256"
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
      upsmon = "master";
    };

    upsmon = {
      enable = true;
      monitor.ups1 = {
        system = "ups1@localhost";
        user = "upsmon";
        passwordFile = config.sops.secrets.nut-upsmon-password.path;
        type = "master";
      };
    };
  };

  # ── PeaNUT dashboard (container) ────────────────────────────────────────────
  virtualisation.oci-containers.containers.peanut = {
    image = "brandawg93/peanut:latest";
    autoStart = true;
    ports = [
      "127.0.0.1:8881:8080"
    ];
    volumes = [
      "/var/lib/peanut:/config"
    ];
    environment = {
      TZ = "Asia/Singapore";
      WEB_PORT = "8080";
      NUT_HOST = netConfig.address;
      NUT_PORT = "3493";
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/peanut 0750 root root -"
  ];

  networking.firewall.allowedTCPPorts = [
    3493
  ];

  # ── Nginx reverse proxy ─────────────────────────────────────────────────────
  services.nginx.virtualHosts."peanut.${acmeConfig.domain}" = {
    forceSSL = true;
    useACMEHost = acmeConfig.domain;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8881";
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
