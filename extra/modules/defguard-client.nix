{
    lib,
    pkgs,
    config,
    ...
}:
let

in {
    options = {
        services.defguard.client = {
            enable = mkEnableOption "Defguard client service";
            package = mkPackageOption pkgs "defguard-client" {};
        };
    };
    config = {

    };
}
