{ pkgs, ...}: {

home.packages = with pkgs; [
  autojump
  zsh-fzf-tab
  ];

programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    dotDir = ".config/zsh";
    plugins = [
      {
        name = "fzf-tab";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
      }
    ];
    #https://github.com/starcraft66/os-config/blob/master/home-manager/programs/zsh.nix
    shellAliases = rec {
      ".."   = "cd ..";
      ls      = "${pkgs.eza}/bin/exa --color=auto --group-directories-first --classify";
      lst     = "${ls} --tree";
      la      = "${ls} --all";
      ll      = "${ls} --all --long --header --group";
      llt     = "${ll} --tree";
      tree    = "${ls} --tree";
      cp      = "cp -iv";
      ln      = "ln -v";
      mkdir   = "mkdir -vp";
      mv      = "mv -iv";
      rm      = "rm -Iv";
      dh      = "du -h";
      df      = "df -h";
      vi      = "nvim";
      v       = "nvim"; 
    };
  };
}