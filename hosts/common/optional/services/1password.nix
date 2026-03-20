{
  config,
  ...
}:
{
  #reference: https://wiki.nixos.org/wiki/1Password
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "${config.hostSpec.username}" ];
  };

  environment.etc = {
        "1password/custom_allowed_browsers" = {
          text = ''
            vivaldi-bin
          '';
          mode = "0755";
        };
      };
}