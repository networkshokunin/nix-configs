{
  description = "Minimal NixOS configuration for bootstrapping systems";

  inputs = {
    # FIXME(starter): adjust nixos version for the minimal environment as desired.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    disko.url = "github:nix-community/disko"; # Declarative partitioning and formatting
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      minimalSpecialArgs = {
        inherit inputs outputs;
        lib = nixpkgs.lib.extend (self: super: { custom = import ../lib { inherit (nixpkgs) lib; }; });
      };

      newConfig =
        name: disk: swapSize:
        (
          let
            diskSpecPath = ../hosts/common/disks/btrfs-disk.nix;
          in
          nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = minimalSpecialArgs;
            modules = [
              inputs.disko.nixosModules.disko
              diskSpecPath
              {
                _module.args = {
                  inherit disk;
                  withSwap = swapSize > 0;
                  swapSize = builtins.toString swapSize;
                };
              }
              ./minimal-configuration.nix
              ../hosts/nixos/${name}/hardware-configuration.nix

              { networking.hostName = name; }
            ];
          }
        );
    in
    {
      nixosConfigurations = {
        # This should mimic what is specified in the respective `nix-config/hosts/[platform]/[hostname]/default.nix`
        # Add entries for each host you will be bootstrapping

        # host = newConfig "name" disk" "swapSize"
        # Swap size is in GiB
        hostname1 = newConfig "hostname1" "/dev/nvme0n1" 16;
      };
    };
}
