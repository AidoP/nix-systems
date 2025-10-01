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
        enableDefaultConfig = false;
        matchBlocks = builtins.listToAttrs (
            builtins.map ({alias, host, user, forwardAgent, ...}: {
                name = alias;
                value = {
                    inherit user forwardAgent;
                    hostname = host;
                };
            }) cfg.sshHosts
        ) // {
            "*" = {
                hashKnownHosts = true;
                serverAliveInterval = 240;
            };
        };
    };

    programs.zsh = {
        enable = true;
        initContent = builtins.readFile ./zshrc;
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

    wayland.windowManager.sway = (import ./sway.nix { inherit config pkgs; });

    xdg.configFile.nvim = {
        enable = true;
        recursive = true;
        source = pkgs.stdenv.mkDerivation rec {
            pname = "nvim-config";
            version = "2eef80eaaab176796f25374608882c34bbf92b82";
            src = pkgs.fetchFromGitHub {
                owner = "AidoP";
                repo = pname;
                rev = version;
                hash = "sha256-0LpPuU05v4W6qBmpWIe3ObwkUozXJavZfq7xoMw98uI=";
            };
            buildPhase = "";
            installPhase = ''
                mkdir -p "$out"
                cp -r lua/ init.lua lazy-lock.json "$out"
            '';
        };
    };
}
