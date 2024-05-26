{
    services.nginx = {
        enable = true;
        recommendedTlsSettings = true;
        recommendedOptimisation = true;
        recommendedGzipSettings = true;
        #recommendedProxySettings = true;
    };

    users.users.nginx.extraGroups = [ "acme" ];

    networking.firewall.allowedTCPPorts = [ 443 ];
}


# +=======+=============+
# | Ports |  Services   |
# +=======+=============+
# | 8001  | Adguardhome |
# +-------+-------------+
