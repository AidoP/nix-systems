{
    config,
    lib,
    pkgs,
    ...
}: let
    inherit (lib)
        mkOption
        types
        ;
    cfg = config.home.users.aidop;
in {
    options = {
        home.users.aidop = {
            email = mkOption {
                type = types.str;
                default = "aidan@trifuse.xyz";
            };
            sshHosts = mkOption {
                type = types.listOf (
                    types.submodule {
                        options = {
                            alias = mkOption { type = types.str; };
                            host = mkOption { type = types.str; };
                            user = mkOption { type = types.str; };
                            mountpoint = mkOption { type = types.str; default = ""; };
                            userDir = mkOption { type = types.str; default = "/"; };
                            forwardAgent = mkOption { type = types.bool; default = false; };
                            c3270 = mkOption {
                                type = types.submodule {
                                    options = {
                                        enable = mkOption { type = types.bool; default = false; };
                                        loginMacro = mkOption { type = types.str; };
                                        codepage = mkOption { type = types.str; default = "cp1047"; };
                                    };
                                };
                            };
                        };
                    }
                );
                default = [];
                example = [{
                    alias = "main";
                    host = "main.example.com";
                    user = "root";
                    mountpoint = "/systems/main";
                }];
            };
        };
    };
    config = let
        sshHostsWithMounts = builtins.filter ({mountpoint, ...}: mountpoint != "") cfg.sshHosts;
    in {

        environment.systemPackages = with pkgs; [
            devenv
        ];

        users.users.aidop = {
            isNormalUser = true;
            extraGroups = [ "wheel" "seat" ];
            shell = pkgs.zsh;
            home = "/home/aidop";
            openssh.authorizedKeys.keys = [];
        };

        # SSH Hosts
        # programs.ssh = {
        #     enable = true;
        #     matchBlocks = {
        #         d3 = {
        #             hostname = "pthekd3.21csw.com.au";
        #             user = "aidanp";
        #         };
        #     };
        # };
        fileSystems = let
            # Use the user's gpg-agent session to query
            # for the password of the SSH key when auto-mounting.
            sshAsUser = pkgs.writeScript "sshAsUser" ''
                user="$1"; shift
                exec ${pkgs.sudo}/bin/sudo -i -u "$user" ${pkgs.openssh}/bin/ssh "$@"
            '';
            options = [
                "_netdev"
                "noauto"
                "user"
                "idmap=user"
                "transform_symlinks"
                "uid=aidop"
                "gid=users"
                "allow_other"
                "noexec"
                "noatime"
                "nosuid"
                "ssh_command=${sshAsUser}\\040aidop"
                "x-gvfs-hide"
                "x-systemd.automount"
                "Compression=yes" # YMMV
                # Disconnect approximately 2*15=30 seconds after a network failure
                "ServerAliveCountMax=1"
                "ServerAliveInterval=15"
                "dir_cache=yes"
                "dcache_timeout=60"
                "dcache_stat_timeout=5"
                "max_conns=2"
                "reconnect"
            ];
        in builtins.listToAttrs (
            builtins.map ({alias, host, user, mountpoint, ...}: {
                name = mountpoint;
                value = {
                    device = "${pkgs.sshfs-fuse}/bin/sshfs#${user}@${host}:/";
                    fsType = "fuse";
                    inherit options;
                };
            }) sshHostsWithMounts
        );
        systemd.automounts = builtins.map ({alias, mountpoint, ...}: {
            where = mountpoint;
            wants = [
                "multi-user.target"
            ];
            automountConfig.TimeoutIdleSec = "5 min";
        }) sshHostsWithMounts;
    };
}
