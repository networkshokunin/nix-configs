# NOTE(starter): configure your audio needs as required.
{ pkgs, ... }:
{
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    jack.enable = true;
  };

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      playerctl # cli utility and lib for controlling media players
      # pamixer # cli pulseaudio sound mixer
      ;
  };
}
