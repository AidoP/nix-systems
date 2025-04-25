{ config, lib, pkgs, ... }: {
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

    # Never change for a system unless completely reset.
    system.stateVersion = "24.11";
}
