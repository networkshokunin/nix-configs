{ inputs, lib, ... }:
{
  hostSpec = {
    hostName = "mgt2";
    users = lib.mkForce [
      "oscar"
    ];

    isImpermanent = lib.mkForce true;
    persistFolder = "/persist";
    primaryUsername = "oscar";
  };
}
