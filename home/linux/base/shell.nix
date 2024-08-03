{ config, myvars, ... }: 
{
  home.homeDirectory = "/home/${myvars.root_username}";

  # # environment variables that always set at login
  # home.sessionVariables = {
  #   # clean up ~
  #   LESSHISTFILE = cache + "/less/history";
  #   LESSKEY = c + "/less/lesskey";
  #   WINEPREFIX = d + "/wine";

  #   # set this variable make i3 failed to start
  #   # related issue:
  #   #   https://github.com/sddm/sddm/issues/871
  #   # XAUTHORITY = "$XDG_RUNTIME_DIR/Xauthority";

  #   # set default applications
  #   BROWSER = "firefox";

  #   # enable scrolling in git diff
  #   DELTA_PAGER = "less -R";
  # };
}
