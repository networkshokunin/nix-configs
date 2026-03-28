{ ... }:
{
  imports = [
    #
    # ========== Required Configs ==========
    #
    common/core

    #
    # ========== Host-specific Optional Configs ==========
    #
    common/optional/sops.nix
    common/optional/services/acme.nix
    common/optional/services/nginx.nix
    common/optional/services/technitium.nix
  ];

}
