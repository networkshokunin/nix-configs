{ inputs, config, ... }:
let
  nix-var-acmePath = "${inputs.nix-secrets}/nix-vars/acme.nix";
  acmeConfig = import "${nix-var-acmePath}";
in  
{

  services.librespeed = {
    enable = true;

  };

  services.nginx.virtualHosts."speedtest.${acmeConfig.domain}" = {
    forceSSL = true;
    useACMEHost = "${acmeConfig.domain}";
    locations."/" = {
        root = "${config.services.librespeed.settings.assets_path}";
        index = "index.html";
      };

    locations."/backend/" = {
      proxy_pass = "http://127.0.0.1:8989/";
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header Host $host;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    };

    # # Equivalent to Caddy's 'respond /servers.json'
    # locations."/servers.json" = {
    #   extraConfig = ''
    #     return 200 '${builtins.toJSON config.services.librespeed.frontend.servers}';
    #     add_header Content-Type application/json;
    #   '';
    # };
  };

}
