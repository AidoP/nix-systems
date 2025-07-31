{ nixos-unstable, defguard-client, hostname, ... }:  nixos-unstable.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
        inherit defguard-client;
        inherit hostname;
    };
    modules = [
        ./configuration.nix
        ../common.nix
    ];
}
