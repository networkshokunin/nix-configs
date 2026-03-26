{ config, ... }:
{
  networking = {
    enableIPv6 = false;
    interfaces = {
      "${config.hostSpec.networking.interface}" = {
          ipv4.addresses = [{
            address = "${config.hostSpec.networking.ipAddress}";
            prefixLength = 24;
        }];
      };
    };
  };  
}