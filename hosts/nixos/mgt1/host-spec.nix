{ inputs, lib, ... }:
{
  hostSpec = {
    hostName = "mgt1";
    users = lib.mkForce [
      "oscar"
    ];

    isImpermanent = lib.mkForce true;
    persistFolder = "/persistent";
    primaryUsername = "oscar";

  };
}