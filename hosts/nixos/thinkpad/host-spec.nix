{  lib, ... }:
{
  hostSpec = {
    hostName = "thinkpad";
    users = lib.mkForce [
      "oscar"
    ];

    isImpermanent = lib.mkForce true;
    persistFolder = "/persist";
    primaryUsername = "oscar";
    use1password = lib.mkForce true;

  };
}
