{ config, inputs, ...}:
let
  networkPath = "${inputs.nix-secrets}/nix-vars/network.nix";
  net = import "${networkPath}" { 
    hostname = config.hostSpec.hostName; 
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