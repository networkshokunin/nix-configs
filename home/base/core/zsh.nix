{ pkgs, ...}: {

home.packages = with pkgs; [
  autojump
  zsh-fzf-tab
  ];

programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
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