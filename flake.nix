{
    description = "NixOS Full Configuration";
    inputs = {
        extra = {
            url = "git+file:.?dir=extra";
            # inputs.nixpkgs.follows = "nixpkgs-unstable";
        };
        # home-manager = {
        #     url = "github:nix-community/home-manager";
        #     inputs.nixpkgs.follows = "nixpkgs-unstable";
        # };
        nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05-small";
        nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable-small";
        ragenix.url = "github:yaxitech/ragenix";
    };
    outputs = inputs@{
        extra,
        nixpkgs-stable,
        nixpkgs-unstable,
        ragenix,
        ...
    }: {
        nixosConfigurations = builtins.mapAttrs (
            hostname:
            values@{
                nixpkgs,
                system,
                modules,
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
                        # home-manager.nixosModules.home-manager
                    ({ pkgs, ... }: {
                        nixpkgs.overlays = [
                            extra.overlays.default
                        ];
                    })
                ] ++modules;
            }
        ) {
            "saifae" = {
                system = "x86_64-linux";
                nixpkgs = nixpkgs-stable;
                modules = [];
            };
            "wulfim" = {
                system = "x86_64-linux";
                nixpkgs = nixpkgs-unstable;
                modules = [
                    extra.nixosModules.defguard-client
                ];
            };
        };
    };
}
