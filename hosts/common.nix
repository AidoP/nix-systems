{ lib, pkgs, hostname, ... }: {
    networking.hostName = hostname;

    # Lock root
    users.users.root = {
        hashedPassword = "!";
    };

    security.sudo = {
        enable = true;
        extraRules = [{
            commands = [ "ALL" ];
            groups = [ "wheel" ];
        }];
    };

    # Boot configuration
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Networking
    networking.wireless.iwd = {
        enable = true;
        settings = {
            General = {
                EnableNetworkConfiguration = false;
            };
            Network = {
                EnableIPv6 = true;
                NameResolvingService = "systemd";
            };
            Settings = {
                AutoConnect = true;
            };
        };
    };
    networking.useNetworkd = true;
    systemd.network = {
        enable = true;
        networks = {
            "10-basic" = {
                name = "en* wlp* wlan*";
                dns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
                networkConfig = {
                    # DNSOverTLS = "yes";
                    DHCP = "yes";
                    MulticastDNS = "yes";
                    LLMNR = "no";
                };
                linkConfig = {
                    RequiredForOnline = "yes";
                };
            };
        };
    };

    # DNS Resolution
    services.resolved = {
        enable = true;
        dnssec = "true";
        #domains = [ "~." ];
        fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
        dnsovertls = lib.mkDefault "true";
        llmnr = "false";
    };

    # Localisation
    time.timeZone = "Australia/Perth";
    i18n.defaultLocale = "en_AU.UTF-8";

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_AU.UTF-8";
        LC_IDENTIFICATION = "en_AU.UTF-8";
        LC_MEASUREMENT = "en_AU.UTF-8";
        LC_MONETARY = "en_AU.UTF-8";
        LC_NAME = "en_AU.UTF-8";
        LC_NUMERIC = "en_AU.UTF-8";
        LC_PAPER = "en_AU.UTF-8";
        LC_TELEPHONE = "en_AU.UTF-8";
        LC_TIME = "ja_JP.UTF-8";
    };

    documentation = {
        dev.enable = true;
        man.generateCaches = true;
    };

    # Packages to always install
    environment.systemPackages = with pkgs; [
        bat
        dig
        fd
        hexyl
        man-pages
        man-pages-posix
        ripgrep
    ];
    programs = {
        git = {
            enable = true;
            config = {
                init = {
                    defaultBranch = "main";
                };
            };
        };
        neovim = {
            enable = true;
            defaultEditor = true;
            withRuby = false;
            withPython3 = false;
            withNodeJs = false;
            vimAlias = true;
            viAlias = true;
        };
        zsh = {
            enable = true;
        };
    };

    # Clean Old Nix Builds
    nix.gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 3d";
    };

    nix.settings.experimental-features = [
        "nix-command"
        "flakes"
    ];
}
