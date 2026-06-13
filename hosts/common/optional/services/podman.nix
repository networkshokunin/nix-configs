{ pkgs, ... }:
{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  virtualisation.oci-containers = {
    backend = "podman";
  };

  # Podman auto-update for containers labeled io.containers.autoupdate=registry.
  # Why: NixOS version here predates `virtualisation.podman.autoUpdate`, so we
  # wire the timer/service manually — equivalent to what the module would do.
  systemd.services.podman-auto-update = {
    description = "Podman auto-update service";
    documentation = [ "man:podman-auto-update(1)" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.podman}/bin/podman auto-update";
      ExecStartPost = "${pkgs.podman}/bin/podman image prune -f";
      TimeoutStartSec = "900s";
      TimeoutStopSec = "10s";
    };
  };

  systemd.timers.podman-auto-update = {
    description = "Podman auto-update timer";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "900";
    };
  };
}
