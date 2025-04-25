{ nixos-stable, hostname, ... }:  nixos-stable.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
        inherit hostname;
    };
    modules = [
        ./configuration.nix
        ../common.nix
    ];
}
