{
    description = "NixOS Full Configuration";
    inputs = {
        extra = {
            url = "./extra";
            # inputs.nixpkgs.follows = "nixpkgs-unstable";
            # inputs.defguard.follows = "defguard";
        };
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs-unstable";
        };
        lanzaboote = {
            url = "github:nix-community/lanzaboote/v0.4.2";
            inputs.nixpkgs.follows = "nixpkgs-unstable";
        };
        nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05-small";
        nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable-small";
        ragenix.url = "github:yaxitech/ragenix";
    };
    outputs = inputs@{
        extra,
        home-manager,
        lanzaboote,
        nixpkgs-stable,
        nixpkgs-unstable,
        ragenix,
        ...
    }: let 
        makeNixosConfiguration = values@{
            hostname,
            nixpkgs,
            system,
            modules,
            users,
            ...
        }: nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = {
                inherit hostname;
            };
            modules = [
                ./secrets/${hostname}.nix
                ./hosts/${hostname}/configuration.nix
                ./hosts/common.nix
                ragenix.nixosModules.default
                ({ pkgs, ... }: {
                    nixpkgs.overlays = [
                        extra.overlays.default
                    ];
                })
                home-manager.nixosModules.home-manager
                {
                    home-manager.useUserPackages = true;
                    home-manager.useGlobalPkgs = true;
                    home-manager.users = users;
                }
            ] ++modules;
        };
        aidop = import ./user/aidop;
    in {
        nixosConfigurations = {
            saifae = makeNixosConfiguration {
                hostname = "saifae";
                system = "x86_64-linux";
                nixpkgs = nixpkgs-stable;
                modules = [];
                users = {};
            };
            wulfim = makeNixosConfiguration {
                hostname = "wulfim";
                system = "x86_64-linux";
                nixpkgs = nixpkgs-unstable;
                modules = [
                    aidop.module
                    extra.nixosModules.defguard-client
                    lanzaboote.nixosModules.lanzaboote
                ];
                users = {
                    aidop = import aidop.home;
                };
            };
        };
    };
}
