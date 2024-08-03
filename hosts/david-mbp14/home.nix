{ lib, config, nix-secrets, myvars, ... }:
let
  wildcard_domain = "*${myvars.domain}";
in
{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      ${wildcard_domain} = {
        forwardAgent = true;
        extraOptions = {IdentityAgent = "'~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock'";};
      };
      "github.com" = {
        forwardAgent = false;
        extraOptions = {IdentityAgent = "'~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock'";};
      };
      "gitlab.com" = {
        forwardAgent = false;
        extraOptions = {IdentityAgent = "'~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock'";};
      };
    };
  };
}

