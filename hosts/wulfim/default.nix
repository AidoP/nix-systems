{ nixos-unstable, extra, hostname, ... }: nixos-unstable.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
        inherit extra hostname;
    };
    modules = [
        ./configuration.nix
        ../common.nix
    ] ++extra.modules;
}
