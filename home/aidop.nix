{
    pkgs,
    ...
}: {
    home.username = "aidop";
    home.homeDirectory = "/home/aidop";
    programs.home-manager.enable = true;

    home.stateVersion = "25.05";
}
