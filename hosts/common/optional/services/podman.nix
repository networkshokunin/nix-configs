{
  ...
}:
{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    autoUpdate.enable = true;
  };

  virtualisation.oci-containers = {
    backend = "podman";
  };
}