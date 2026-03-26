{ config, inputs, ...}:
let
  nix-var-networkPath = "${inputs.nix-secrets}/nix-vars/network.nix";
  netConfig = import "${nix-var-networkPath}" { 
    hostname = config.hostSpec.hostName; 
  };
in
{
  networking = {
    enableIPv6 = false;
    interfaces."${netConfig.interface}" = {
      ipv4.addresses = [{
        address = netConfig.address;
        prefixLength =  netConfig.prefixLength;
      }];
    };

    defaultGateway = {
      address = netConfig.gateway;
    };

    nameservers = netConfig.nameservers;
  };
}