{ nixos, ragenix, hostname, ... }:  nixos.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
        inherit hostname;
        inherit ragenix;
    };
    modules = [
        ./configuration.nix
        ../common.nix
        ragenix.nixosModules.default
        ../../secrets/${hostname}.nix
    ];
}
