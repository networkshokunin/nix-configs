{ pkgs, ...}:
{
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      completionInit = "autoload -U compinit && compinit\nsource ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh";
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        wg-up    = "sudo wg-quick up wg0";
        wg-down  = "sudo wg-quick down wg0";
        wg-show  = "sudo wg show";
        jj = "ji";
      };
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
    ];
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    # Replace 'z' with 'j'
    options = [
      "--cmd j"
    ];
  };

}