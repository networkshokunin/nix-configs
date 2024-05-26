{ pkgs, ... }: 
{
  # Set your time zone.
  time.timeZone = "Asia/Singapore";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  
  console = {
    earlySetup = true;
    keyMap = "us";
    packages = with pkgs; [ terminus_font ];
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
    #use fc-list to list the fonts installed and then set the font
    #https://wiki.archlinux.org/title/HiDPI#Linux_console_(tty)
  };

}