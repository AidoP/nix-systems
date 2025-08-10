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
        mkPackageOption;
    cfg = config.services.defguard-service;
in {
    options = {
        services.defguard-service = {
            enable = mkEnableOption "Defguard interface daemon service";
            package = mkPackageOption pkgs "defguard-client" {};
        };
    };
    config = mkIf cfg.enable {
        systemd.services.defguard-service = {
            description = "Defguard interface daemon service";
            after = [ "network-online.target" ];
            wants = [ "network-online.target" ];
            wantedBy = [ "multi-user.target" ];
            path = [
                pkgs.iproute2
            ];
            serviceConfig = {
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
