{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # Misc
    vim
    tldr
    tree
    which

    # search for files by name, faster than find
    fd
    jq
    gnumake # a command runner like make, but simpler
    delta # A viewer for git and diff output
    # lazygit # Git terminal UI.
    # gping # ping, but with a graph(TUI)
    # duf # Disk Usage/Free Utility - a better 'df' alternative
    # du-dust # A more intuitive version of `du` in rust
    # gdu # disk usage analyzer(replacement of `du`)

    # nix related
    #
    # it provides the command `nom` works just like `nix
    # with more details log output
    nix-output-monitor
    hydra-check # check hydra(nix's build farm) for the build status of a package
    nix-index # A small utility to index nix store paths
    nix-init # generate nix derivation from url
    # https://github.com/nix-community/nix-melt
    nix-melt # A TUI flake.lock viewer
    # https://github.com/utdemir/nix-tree
    nix-tree # A TUI to visualize the dependency graph of a nix derivation

    # productivity
    #ncdu # analyzer your disk usage Interactively, via TUI(replacement of `du`)
  ];

  programs = {
  #  eza = {
  #    enable = true;
  #    git = true;
  #    icons = true;
  #  };

    bat = {
      enable = true;
      # config = {
      #   pager = "less -FR";
      #   theme = "catppuccin-mocha";
      # };
      # themes = {
      #   # https://raw.githubusercontent.com/catppuccin/bat/main/Catppuccin-mocha.tmTheme
      #   catppuccin-mocha = {
      #     src = nur-ryan4yin.packages.${pkgs.system}.catppuccin-bat;
      #     file = "Catppuccin-mocha.tmTheme";
      #   };
      };

    # A command-line fuzzy finder
    fzf = {
      enable = true;
      enableZshIntegration = true;
      # https://github.com/catppuccin/fzf
      # catppuccin-mocha
      # colors = {
      #   "bg+" = "#313244";
      #   "bg" = "#1e1e2e";
      #   "spinner" = "#f5e0dc";
      #   "hl" = "#f38ba8";
      #   "fg" = "#cdd6f4";
      #   "header" = "#f38ba8";
      #   "info" = "#cba6f7";
      #   "pointer" = "#f5e0dc";
      #   "marker" = "#f5e0dc";
      #   "fg+" = "#cdd6f4";
      #   "prompt" = "#cba6f7";
      #   "hl+" = "#f38ba8";
      # };
    };
  };
}
