{ lib, inputs, config, pkgs, ... }:
let
  sopsFolder = builtins.toString inputs.nix-secrets;
  wgFilePath = "${sopsFolder}/sops/wireguard-${config.hostSpec.hostName}.yaml";
in  
{
  sops.secrets = lib.mkMerge [
    {
      "localAdd"      = { sopsFile = wgFilePath; };
      "dns"           = { sopsFile = wgFilePath; };
      "privateKey"    = { sopsFile = wgFilePath; };
      "presharedKey"  = { sopsFile = wgFilePath; };
      "peerEndpoint"  = { sopsFile = wgFilePath; };
      "peerPublicKey" = { sopsFile = wgFilePath; };
    }
  ];

  sops.templates."wg0.conf" = {
      content = ''
        [Interface]
        Address = ${config.sops.placeholder.localAdd}
        DNS = ${config.sops.placeholder.dns}
        PrivateKey = ${config.sops.placeholder.privateKey}

        [Peer]
        PublicKey = ${config.sops.placeholder.peerPublicKey}
        PresharedKey = ${config.sops.placeholder.presharedKey}
        Endpoint = ${config.sops.placeholder.peerEndpoint}
        AllowedIPs = 0.0.0.0/0
        PersistentKeepalive = 15
      '';
    };

    networking.wg-quick.interfaces.wg0 = {
      configFile = config.sops.templates."wg0.conf".path;
    };
}