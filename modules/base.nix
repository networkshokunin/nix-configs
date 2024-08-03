{
  pkgs,
  myvars,
  nuenv,
  ...
} @ args: {
  nixpkgs.overlays =
    [
      #nuenv.overlays.default https://determinate.systems/posts/nuenv/
    ]
    ++ (import ../overlays args);

  # auto upgrade nix to the unstable version
  # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/tools/package-management/nix/default.nix#L284
  nix.package = pkgs.nixVersions.latest;

  environment.systemPackages = with pkgs; [
    git # used by nix flakes

    # archives
    zip
    xz
    zstd
    unzip
    p7zip

    # Text Processing
    # Docs: https://github.com/learnbyexample/Command-line-text-processing
    gnugrep # GNU grep, provides `grep`/`egrep`/`fgrep`
    gnused # GNU sed, very powerful(mainly for replacing text in files)
    gawk # GNU awk, a pattern scanning and processing language
    jq # A lightweight and flexible command-line JSON processor

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils # `dig` + `nslookup`
    wget
    curl
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    nmap # A utility for network discovery and security auditing

    # misc
    file
    findutils
    which
    tree
    gnutar
    rsync
    bat
  ];

  programs.zsh.enable = true;
  environment.shells = [
    pkgs.zsh
  ];

  nix.settings = {
    # enable flakes globally
    experimental-features = ["nix-command" "flakes"];

    # given the users in this list the right to specify additional substituters via:
    #    1. `nixConfig.substituers` in `flake.nix`
    #    2. command line args `--options substituers http://xxx`
    trusted-users = [myvars.root_username myvars.osx_username];

    # substituers that will be considered before the official ones(https://cache.nixos.org)
    substituters = [
      "https://nix-community.cachix.org"
    ];

    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    builders-use-substitutes = true;
  };

}
