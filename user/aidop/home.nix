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


    home.packages = with pkgs; [
        (writeShellScriptBin "dino" ''
            #!/bin/sh
            ALIAS="$1"
            if [ -z "$ALIAS" ]; then
                echo "Usage: $0 <system>"
                exit 1
            fi
            echo -en "\033]0;3270 $ALIAS\a"
            exec c3270 "$HOME/.config/c3270/$ALIAS.c3270"
        '')
    ];

    programs.git = {
        enable = true;
        userName = "Aidan Prangnell";
        userEmail = cfg.email;
    };

    programs.ssh = {
        enable = true;
        serverAliveInterval = 240;
        hashKnownHosts = true;
        matchBlocks = builtins.listToAttrs (
            builtins.map ({alias, host, user, forwardAgent, ...}: {
                name = alias;
                value = {
                    inherit user forwardAgent;
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
    ) // builtins.listToAttrs (
        builtins.map ({alias, c3270, host, user, mountpoint, ...}: {
            name = ".config/c3270/${alias}.c3270";
            value = let
                loginMacro = if c3270.loginMacro != "" then "\nc3270.loginMacro: ${c3270.loginMacro}" else "";
            in {
                text = ''
                    c3270.hostname: ${host}
                    c3270.codePage: ${c3270.codepage}
                    c3270.oversize: 160x90
                '' + loginMacro;
            };
        }) (builtins.filter ({c3270, ...}: c3270.enable) cfg.sshHosts)
    ) // {

    };
}
