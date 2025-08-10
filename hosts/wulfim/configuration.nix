{ config, lib, pkgs, ... }: let
    sshHosts = [
        {
            alias = "a1";
            host = "pthbra1.21csw.com.au";
            user = "aidanp";
            mountpoint = "/mf/a1";
            userDir = "/BRA1/u/aidanp";
        }
        {
            alias = "d1";
            host = "pthekd1.21csw.com.au";
            user = "aidanp";
            mountpoint = "/mf/d1";
            userDir = "/EKD1/u/aidanp";
        }
        {
            alias = "d2";
            host = "pthekd2.21csw.com.au";
            user = "aidanp";
            mountpoint = "/mf/d2";
            userDir = "/EKD2/u/aidanp";
        }
        {
            alias = "d3";
            host = "pthekd3.21csw.com.au";
            user = "aidanp";
            mountpoint = "/mf/d3";
            userDir = "/EKD3/u/aidanp";
        }
        {
            alias = "k1";
            host = "pthsok1.21csw.com.au";
            user = "aidanp";
            mountpoint = "/mf/k1";
            userDir = "/u/aidanp";
        }
        {
            alias = "n1";
            host = "pthtrn1.21csw.com.au";
            user = "aidanp";
            mountpoint = "/mf/n1";
            userDir = "/u/aidanp";
        }
    ];
in {
    imports = [
        ./hardware-configuration.nix
    ];

    nixpkgs.config = {
        allowUnfree = true;
        permittedInsecurePackages = [
            "libsoup-2.74.3"
        ];
    };

    home.users.aidop = {
        inherit sshHosts;
        email = "aidan.prangnell@21cs.com";
    };

    # Use latest kernel.
    boot.kernelPackages = pkgs.linuxPackages_latest;

    hardware.enableRedistributableFirmware = true;
    hardware.graphics = {
        enable = true;
    };
    services.xserver.videoDrivers = [ "displaylink" "modesetting" ];

    services.defguard-service = {
        enable = true;
    };
    services.resolved = {
        dnsovertls = "opportunistic";
    };
    # systemd.network = {
    #     networks = {
    #         "20-vpn" = {
    #             name = "wg*";
    #             networkConfig = {
    #                 DNSOverTLS = "no";
    #                 DHCP = "yes";
    #                 MulticastDNS = "yes";
    #                 LLMNR = "no";
    #             };
    #             linkConfig = {
    #                 RequiredForOnline = "no";
    #             };
    #         };
    #     };
    # };

    networking.hostId = "0ab002a9";

    environment.systemPackages = with pkgs; [
        bitwarden-cli
        bitwarden-desktop
        defguard-client
        displaylink
        firefox
        fzf
        gnumake
        gnupg
        lld_19
        llvmPackages_19.bintools
        llvmPackages_19.libcxxClang
        mako
        meson
        pinentry-curses
        rbw
        rofi-rbw-wayland
        rustup
        teams-for-linux
        thunderbird
        wl-clipboard
    ];

    fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
        # nerd-fonts.fira-code
        nerd-fonts.noto
    ];

    systemd.services.dlm.wantedBy = [ "multi-user.target" ];

    # services.displayManager.lemurs = {
    #     enable = true;
    #     vt = 1;
    #     settings = {
    #
    #     };
    # };
    services.gnome.gnome-keyring.enable = true;

    programs.sway = {
        enable = true;
        wrapperFeatures.gtk = true;
        extraPackages = with pkgs; [
            swaylock
            alacritty
            bemenu
            pinentry-bemenu
            j4-dmenu-desktop
            grim
        ];
    };
    programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
        pinentryPackage = pkgs.pinentry-curses;
    };
    qt.style = "breeze";

    # Never change for a system unless completely reset.
    system.stateVersion = "25.05";
}
