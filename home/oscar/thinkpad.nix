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
    # FIXME(starter): add or remove any optional config directories or files here
    common/optional/browsers/vivaldi
    common/optional/terminals/ghostty
    common/optional/sops.nix
    common/optional/ide/cursor
    common/optional/terminals/screen
    common/optional/terminals/sops
  ];

}
