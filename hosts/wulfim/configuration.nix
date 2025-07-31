{ config, lib, pkgs, defguard-client, ... }: let
in {
    imports = [
        ./hardware-configuration.nix
    ];

    nixpkgs.config.allowUnfree = true;

    # Use latest kernel.
    boot.kernelPackages = pkgs.linuxPackages_latest;

    hardware.enableRedistributableFirmware = true;
    hardware.graphics = {
        enable = true;
    };
    services.xserver.videoDrivers = [ "displaylink" "modesetting" ];

    networking.hostId = "0ab002a9";

    users.users.aidop = {
        isNormalUser = true;
        extraGroups = [ "wheel" "seat" ];
        shell = pkgs.zsh;
        home = "/home/aidop";
        openssh.authorizedKeys.keys = [];
    };

    environment.systemPackages = with pkgs; [
        bitwarden-desktop
        bitwarden-cli
        defguard-client
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
    #     settings = {
    #
    #     };
    # };
    #
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
