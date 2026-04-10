{ pkgs, ... }: 
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}