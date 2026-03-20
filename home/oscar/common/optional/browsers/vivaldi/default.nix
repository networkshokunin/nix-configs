{
  pkgs,
  ...
}:
{
  programs.chromium = {
    enable = true;
    extensions = [
      { id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa"; } # 1password
    ];
    package = pkgs.vivaldi;
  };
}

