{ lib, nix-vars }:

let
  vars = import "${nix-vars}/vars.nix";
  hostsAddr = vars.hostsAddr;
  prefixLength = vars.prefixLength;

  hostsInterface = lib.attrsets.mapAttrs
      (key: val: {
        interfaces."${val.iface}" = {
          useDHCP = false;
          ipv4.addresses = [
            {
              inherit prefixLength;
              address = val.ipv4;
            }
          ];
        };
      })
      hostsAddr;
in {
  root_username = vars.root_username;
  osx_username = vars.osx_username;
  fullname = vars.fullname;
  email = vars.email;
  domain = vars.domain;

  networking = {
    hostsInterface = hostsInterface;
    defaultGateway = (builtins.head (builtins.attrValues hostsAddr)).defaultGateway;
    domain = vars.domain;
    nameservers = vars.nameservers;
    timeServers = vars.timeServers;
  };

  networking.ssh = {
    extraConfig =
      lib.attrsets.foldlAttrs
        (acc: host: val:
          acc
          + ''
            Host ${host}
              HostName ${val.ipv4}
              Port 22
          '')
        ""
        hostsAddr;

    knownHosts =
      lib.attrsets.mapAttrs
        (host: value: {
          hostNames = [host hostsAddr.${host}.ipv4];
          publicKey = value.publicKey;
        })
        {
          # Uncomment and add your public keys here
          # david.publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ7X82I2M5GWwCnXugSceeFn4sSUexcoth4aRkZLyzkz";
        };
  };
}
