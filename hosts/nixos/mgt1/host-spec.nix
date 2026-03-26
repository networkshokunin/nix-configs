{ inputs, lib, ... }:
{
  hostSpec = {
    hostName = "mgt1";
    users = lib.mkForce [
      "oscar"
    ];

    isImpermanent = lib.mkForce true;
    persistFolder = "/persist";
    primaryUsername = "oscar";
    networking = {
      interface = "enp1s0";
      ipAddress = "10.168.10.194";
      prefix = 24;
    };


  };
}