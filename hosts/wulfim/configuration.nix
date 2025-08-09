{ config, lib, pkgs, ... }: {
    imports = [
        ./hardware-configuration.nix
    ];

    nixpkgs.config = {
        allowUnfree = true;
        permittedInsecurePackages = [
            "libsoup-2.74.3"
        ];
    };

    # home-manager.users.aidop = {
    #     home.stateVersion = "25.05";
    # };

    # Use latest kernel.
    boot.kernelPackages = pkgs.linuxPackages_latest;

    hardware.enableRedistributableFirmware = true;
    hardware.graphics = {
        enable = true;
    };
    services.xserver.videoDrivers = [ "displaylink" "modesetting" ];

    services.defguard-service = {
        # enable = true;
        package = pkgs.defguard-client;
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

    users.users.aidop = {
        isNormalUser = true;
        extraGroups = [ "wheel" "seat" ];
        shell = pkgs.zsh;
        home = "/home/aidop";
        openssh.authorizedKeys.keys = [];
    };

    environment.systemPackages = with pkgs; [
        dig
        defguard-client
        bitwarden-desktop
        bitwarden-cli
        displaylink
        fd
        firefox
        llvmPackages_19.bintools
        llvmPackages_19.libcxxClang
        lld_19
        gnupg
        mako
        meson
        noto-fonts
        pinentry-curses
        rbw
        rofi-rbw-wayland
        ripgrep
        rustup
        teams-for-linux
        thunderbird
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
