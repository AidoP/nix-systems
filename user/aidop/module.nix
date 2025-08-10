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
                            mountpoint = mkOption { type = types.str; };
                            userDir = mkOption { type = types.str; default = "/"; };
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
    config = {

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
                "user"
                "uid=aidop"
                "gid=users"
                "allow_other"
                "noexec"
                "noatime"
                "nosuid"
                "_netdev"
                "ssh_command=${sshAsUser}\\040aidop"
                "noauto"
                "x-gvfs-hide"
                "x-systemd.automount"
                #"Compression=yes" # YMMV
                # Disconnect approximately 2*15=30 seconds after a network failure
                "ServerAliveCountMax=1"
                "ServerAliveInterval=15"
                "dir_cache=no"
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
            }) cfg.sshHosts
        );
        systemd.automounts = builtins.map ({alias, mountpoint, ...}: {
            where = mountpoint;
            automountConfig.TimeoutIdleSec = "5 min";
        }) cfg.sshHosts;
    };
}
