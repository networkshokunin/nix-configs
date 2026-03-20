{
  pkgs,
  ...
}:
{
  programs.vivaldi = {
    enable = true;
    extensions = [
      { id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa"; } # 1password
    ];
  };
}

