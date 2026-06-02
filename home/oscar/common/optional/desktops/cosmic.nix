{ ... }:
{
  # cosmic-comp reads its keyboard config from this file; services.xserver.xkb.options
  # is ignored under COSMIC.
  xdg.configFile."cosmic/com.system76.CosmicComp/v1/xkb_config".text = ''
    (
        rules: "",
        model: "pc104",
        layout: "us",
        variant: "",
        options: Some("caps:super,terminate:ctrl_alt_bksp"),
        repeat_delay: 600,
        repeat_rate: 25,
    )
  '';

  xdg.configFile."cosmic/com.system76.CosmicSettings.Shortcuts/v1/custom".text = ''
    {
        (
            modifiers: [Super, Shift],
            key: "l",
        ): Disable,
        (
            modifiers: [Super, Shift],
            key: "Right",
        ): Disable,
        (
            modifiers: [Super],
            key: "Left",
        ): Move(Left),
        (
            modifiers: [Shift],
            key: "Left",
        ): Disable,
        (
            modifiers: [Super],
            key: "Right",
        ): Move(Right),
    }
  '';
}
