{ config, inputs, ...}:
let
  netPath = builtins.toString inputs.nix-secrets;
  net = import "${netPath}/nix-vars/network.nix" { 
    hostname = config.hostSpec.hostname; 
  };
in
{
  networking = {
    enableIPv6 = false;
    interfaces."${net.interface}" = {
      ipv4.addresses = [{
        address = net.address;
        prefixLength = net.prefixLength;
      }];
    };

    defaultGateway = {
      address = net.gateway;
    };

    nameservers = net.nameservers;
  };
}