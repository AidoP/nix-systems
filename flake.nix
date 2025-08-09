{
    description = "NixOS Full Configuration";
    inputs = {
        extra.url = "./extra";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs-unstable";
        };
        nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05-small";
        nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable-small";
        ragenix.url = "github:yaxitech/ragenix";
    };
    outputs = inputs@{
        # home-manager,
        nixpkgs-stable,
        nixpkgs-unstable,
        ragenix,
        ...
    }: let
        local-pkgs = import ./packages;
    in {
        nixosConfigurations = builtins.mapAttrs (
            hostname:
            values@{
                nixpkgs,
                ...
            }: nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                specialArgs = {
                    inherit hostname local-pkgs;
                };
                modules = [
                    ./hosts/${hostname}/configuration.nix
                    ./hosts/common.nix
                        # home-manager.nixosModules.home-manager
                ] ++ import ./modules;
            }
        ) {
            "saifae" = {
                nixpkgs = nixpkgs-stable;
            };
            "wulfim" = {
                nixpkgs = nixpkgs-unstable;
            };
        };
    };
}
