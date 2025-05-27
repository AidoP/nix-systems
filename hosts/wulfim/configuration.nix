{ config, lib, pkgs, ... }: let
in {
    imports = [
        ./hardware-configuration.nix
    ];

    # Use latest kernel.
    boot.kernelPackages = pkgs.linuxPackages_latest;

    hardware.enableRedistributableFirmware = true;

    networking.hostId = "0ab002a9";

    users.users.aidop = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        shell = pkgs.zsh;
        home = "/home/aidop";
        openssh.authorizedKeys.keys = [];
    };

    environment.systemPackages = with pkgs; [
        rustup
        llvmPackages_19.bintools
        llvmPackages_19.libcxxClang
        lld_19
        meson
    ];


    # Never change for a system unless completely reset.
    system.stateVersion = "25.05";
}
