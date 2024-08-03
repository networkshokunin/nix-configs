{
  pkgs,
  myvars,
  nuenv,
  ...
} @ args: {

  users.users.${myvars.osx_username} = {
    description = myvars.fullname;
    # Public Keys that can be used to login to all my PCs, Macbooks, and servers.
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ7X82I2M5GWwCnXugSceeFn4sSUexcoth4aRkZLyzkz"
    ];
  };
}
