{ config, lib, pkgs, ... }: {
    imports = [
        ./hardware-configuration.nix
    ];

    networking.hostId = "f7fb8403";

    systemd.tmpfiles.rules = [
        "d /srv/.well-known 1775 acme acme 1d"
    ];

    users.users.aidop = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        shell = pkgs.zsh;
        home = "/home/aidop";
        openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO+liULxKXZsHRTrxEKT5IgFK7n9K/GziW2ilhRPKc6l aidop@lorix"
        ];
    };

    environment.systemPackages = with pkgs; [
        rustup
        llvmPackages_19.bintools
        llvmPackages_19.libcxxClang
        lld_19
        meson
    ];

    # Enable the OpenSSH daemon.
    services.openssh = {
        enable = true;
        settings = {
            KbdInteractiveAuthentication = false;
            PasswordAuthentication = false;
            PermitRootLogin = "no";
        };
    };

    networking.nftables.enable = true;
    networking.firewall = {
        enable = true;
        allowedTCPPorts = [ 80 443 8096 ];
    };
    networking.nat = {
        enable = true;
        internalInterfaces = ["ve-*"];
        externalInterface = "wlan0";
        enableIPv6 = true;
        forwardPorts = [
            {
                destination = "192.168.2.1:443";
                proto = "tcp";
                sourcePort = 443;
            }
            {
                destination = "192.168.2.2:8096";
                proto = "tcp";
                sourcePort = 8096;
            }
        ];
    };

# security.acme.defaults.server = "https://acme-staging-v02.api.letsencrypt.org/directory";
#
#     users.groups.trifuse-xyz = { gid = 10001; };
#     security.acme = {
#         acceptTerms = true;
#         defaults = {
#             email = "admin@trifuse.xyz";
#             keyType = "ec256";
#         };
#         certs."trifuse.xyz" = {
#             reloadServices = [ "container@www" ];
#             listenHTTP = ":80";
#             group = "trifuse-xyz";
#         };
#     };
#
    containers.www = {
        autoStart = true;
        privateNetwork = true;
        hostAddress = "192.168.1.103";
        localAddress = "192.168.2.1";
        bindMounts = {
            # "/var/lib/acme" = {
            #     isReadOnly = true;
            # };
            "/srv" = {
                isReadOnly = true;
            };
        };
        config = { config, pkgs, lib, ... }: {
            system.stateVersion = "24.11";
            environment.defaultPackages = [];
            networking.nftables.enable = true;
            networking.firewall = {
                enable = true;
                allowedTCPPorts = [ 443 ];
            };
            services.static-web-server = {
                enable = true;
                listen = "[::]:443";
                root = "/srv";
                configuration = {
                    general = {
                        directory-listing = true;
                        http2 = true;
                        http2-tls-cert = config.age.secrets.trifuse-xyz-cert.path;
                        http2-tls-key = config.age.secrets.trifuse-xyz-key.path;
                        security-headers = true;
                    };
                };
            };
            # users.groups.trifuse-xyz = { gid = 10001; };
            # systemd.services.static-web-server.serviceConfig.SupplementaryGroups = pkgs.lib.mkForce [ "" "trifuse-xyz" ];
        };
    };

    containers.jellyfin = {
        autoStart = true;
        privateNetwork = true;
        hostAddress = "192.168.1.103";
        localAddress = "192.168.2.2";
        config = { config, pkgs, lib, ... }: {
            system.stateVersion = "24.11";
            environment.defaultPackages = [];
            networking.nftables.enable = true;
            networking.firewall = {
                enable = true;
                allowedTCPPorts = [ 8096 ];
            };
            hardware.graphics.enable = true;
            # services.resolved.enable = true;
            services.jellyfin = {
                enable = true;
            };
        };
    };

    # Never change for a system unless completely reset.
    system.stateVersion = "24.11";
}
