{ nixos-stable, ragenix, hostname, ... }:  nixos-stable.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
        inherit hostname;
    };
    modules = [
        ./configuration.nix
        ../common.nix
        ragenix.nixosModules.default
        ../../secrets/${hostname}.nix
    ];
}
