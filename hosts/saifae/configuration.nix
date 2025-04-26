{ config, lib, pkgs, ... }: let
    trifuse-xyz-cert = config.age.secrets.trifuse-xyz-cert.path;
    trifuse-xyz-key = config.age.secrets.trifuse-xyz-key.path;
    ddclient-trifuse-xyz-token = config.age.secrets.ddclient-trifuse-xyz-token.path;
in {
    imports = [
        ./hardware-configuration.nix
    ];

    networking.hostId = "f7fb8403";

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
        allowedTCPPorts = [ 443 8096 ];
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

    services.ddclient = {
        enable = true;
        domains = [ "trifuse.xyz" ];
        usev4 = "webv4, webv4=ipify-ipv4";
        usev6 = "disabled";
        protocol = "cloudflare";
        passwordFile = ddclient-trifuse-xyz-token;
        username = "token";
        zone = "trifuse.xyz";
    };

    users.groups.trifuse-xyz = {};
    containers.www = {
        autoStart = true;
        privateNetwork = true;
        hostAddress = "192.168.1.103";
        localAddress = "192.168.2.1";
        bindMounts = {
            "${trifuse-xyz-cert}" = {
                isReadOnly = true;
            };
            "${trifuse-xyz-key}" = {
                isReadOnly = true;
            };
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
            users.groups.trifuse-xyz = {};
            services.static-web-server = {
                enable = true;
                listen = "[::]:443";
                root = "/srv";
                configuration = {
                    general = {
                        directory-listing = false;
                        http2 = true;
                        http2-tls-cert = trifuse-xyz-cert;
                        http2-tls-key = trifuse-xyz-key;
                        security-headers = true;
                    };
                };
            };
            systemd.services.static-web-server.serviceConfig.SupplementaryGroups = pkgs.lib.mkForce [ "" "trifuse-xyz" ];
        };
    };

    containers.jellyfin = {
        autoStart = true;
        privateNetwork = true;
        hostAddress = "192.168.1.103";
        localAddress = "192.168.2.2";
        bindMounts = {
            "/main/media" = {
                isReadOnly = true;
            };
        };
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

    hardware.enableRedistributableFirmware = true;

    # Never change for a system unless completely reset.
    system.stateVersion = "24.11";
}
