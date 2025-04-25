{ pkgs, hostname, ... }: {
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
    networking.wireless.iwd.enable = true;
    networking.useNetworkd = true;
    systemd.network = {
        enable = true;
        networks = {
            "10-basic" = {
                matchConfig.Name = "en* wlp* wlan*";
                networkConfig = {
                    DHCP = "yes";
                };
                linkConfig.RequiredForOnline = "no";
            };
        };
    };

    # DNS Resolution
    services.resolved = {
        enable = true;
        dnssec = "true";
        domains = [ "~." ];
        fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
        dnsovertls = "true";
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

    # Packages to always install
    environment.systemPackages = with pkgs; [
        git
        neovim
        zsh
    ];
    programs = {
        zsh = {
            enable = true;
        };
    };

    # Clean Old Nix Builds
    nix.gc = {
        automatic = true;
        dates = "monthly";
        options = "--delete-older-than 1m";
    };

    nix.settings.experimental-features = [
        "nix-command"
        "flakes"
    ];
}
