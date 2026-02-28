# Add your core services to the same directory as this default.nix file.
# They will automatically be imported below.
{
  lib,
  ...
}:
{
  imports = (lib.custom.scanPaths ./.);
}
