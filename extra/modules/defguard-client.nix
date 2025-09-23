{
    lib ? pkgs.lib,
    config,
    pkgs,
    ...
}:
let
    inherit (lib)
        getExe'
        mkEnableOption
        mkIf
        mkOption
        mkPackageOption
        types;
    cfg = config.services.defguard-service;
in {
    options = {
        services.defguard-service = {
            enable = mkEnableOption "Defguard interface daemon service";
            package = mkPackageOption pkgs "defguard-client" {};
            # user = mkOption { type = types.str; default = "defguard"; };
            group = mkOption { type = types.str; default = "defguard"; };
        };
    };
    config = mkIf cfg.enable {
        users.groups.${cfg.group} = {};
        systemd.services.defguard-service = {
            description = "Defguard interface daemon service";
            after = [ "network-online.target" ];
            wants = [ "network-online.target" ];
            wantedBy = [ "multi-user.target" ];
            path = [
                pkgs.iproute2
            ];
            serviceConfig = {
                #DynamicUser = true;
                #LogsDirectory = "defguard-service";
                #RuntimeDirectory = "defguard-service";
                #User = cfg.user;
                Group = cfg.group;
                ExecReload="/bin/kill -HUP $MAINPID";
                ExecStart=getExe' cfg.package "defguard-service";
                KillMode="process";
                KillSignal="SIGINT";
                LimitNOFILE=65536;
                LimitNPROC="infinity";
                Restart="on-failure";
                RestartSec=2;
                TasksMax="infinity";
                OOMScoreAdjust=-1000;
            };
        };
    };
}
