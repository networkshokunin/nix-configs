_:
#############################################################
#
#  david-mbp14 - MacBook Pro 2024 14-inch M2 32G
#
#############################################################
let
  hostname = "david-mbp14";
in {
  networking.hostName = hostname;
  networking.computerName = hostname;
  system.defaults.smb.NetBIOSName = hostname;
}
