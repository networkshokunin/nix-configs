{
  config,
  ...
}:
let
  # FIXME(starter): if you are not defining ports in your "soft" nix-secrets, you can 
  # replace the following line with: sshPort = 22; 
  # and substitute 22 with a custom port number if needed.
  sshPort = config.hostSpec.networking.ports.tcp.ssh;
in

{
  services.openssh = {
    enable = true;
    ports = [ sshPort ];

    settings = {
      # Harden
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      # Automatically remove stale sockets
      StreamLocalBindUnlink = "yes";
      # Allow forwarding ports to everywhere
      GatewayPorts = "clientspecified";
    };

    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  networking.firewall.allowedTCPPorts = [ sshPort ];
}
