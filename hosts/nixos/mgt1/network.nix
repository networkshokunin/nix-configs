{ config, ... }:
{
  networking = {
    enableIPv6 = false;
    interfaces = {
      "${config.hostSpec.interface}" = {
          ipv4.addresses = [{
          address = "${config.hostSpec.ipAddress}";
          prefixLength = "${config.hostSpec.prefix}";
        }];
      };
    };
  };
}