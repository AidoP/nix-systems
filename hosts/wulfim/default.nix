{ nixos, extra, hostname, home-manager, ... }: nixos.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
        inherit extra hostname;
    };
    modules = [
        ./configuration.nix
        ../common.nix
        home-manager.nixosModules.home-manager
    ] ++extra.modules;
}
