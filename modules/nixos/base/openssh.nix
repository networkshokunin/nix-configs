{ lib, myvars, ...}: 
{
  networking.firewall.allowedTCPPorts = [ 22 ];

  #networking.firewall.enable = lib.mkDefault false;

  programs.ssh = myvars.networking.ssh;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      # root user is used for remote deployment, so we need to allow it
      PermitRootLogin = "no";
      PasswordAuthentication = false; # disable password login
    };
    hostKeys = [
      { type = "ed25519"; path = "/persistent/etc/ssh/ssh_host_ed25519_key"; }
      { type = "rsa"; bits = 4096; path = "/persistent/etc/ssh/ssh_host_rsa_key"; }
    ];
  };

  # Passwordless sudo when SSH'ing with keys
  security.pam.sshAgentAuth.enable = true;

  # Add terminfo database of all known terminals to the system profile.
  # https://github.com/NixOS/nixpkgs/blob/nixos-24.05/nixos/modules/config/terminfo.nix
  environment.enableAllTerminfo = true;
}
