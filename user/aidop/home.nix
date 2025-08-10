{
    config,
    lib,
    osConfig,
    pkgs,
    ...
}: let
    cfg = osConfig.home.users.aidop;
in {
    home.stateVersion = "25.05";

    home.username = "aidop";
    home.homeDirectory = "/home/aidop";
    programs.home-manager.enable = true;

    programs.git = {
        enable = true;
        userName = "Aidan Prangnell";
        userEmail = cfg.email;
    };

    programs.ssh = {
        enable = true;
        matchBlocks = builtins.listToAttrs (
            builtins.map ({alias, host, user, ...}: {
                name = alias;
                value = {
                    inherit user;
                    hostname = host;
                };
            }) cfg.sshHosts
        );
    };

    home.file = builtins.listToAttrs (
        builtins.map ({alias, mountpoint, userDir, ...}: {
            name = alias;
            value = {
                source = config.lib.file.mkOutOfStoreSymlink "${mountpoint}/${userDir}";
            };
        }) cfg.sshHosts
    );
}
