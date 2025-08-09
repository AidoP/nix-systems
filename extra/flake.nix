{
    description = "Extra Packages";
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05-small";
    };
    outputs = {
        self,
        nixpkgs,
        nix,
        ...
    }: let
        systems = [
            "x86_64-linux"
        ];

        overlayList = [
            self.overlays.default
        ];

        forEachSystem = nixpkgs.lib.genAttrs systems;
        pkgsBySystem = forEachSystem (system: import nixpkgs {
            inherit system;
            overlays = overlayList;
        });
    in {
        overlays.default = final: prev: {
            defguard-client = final.callPackage ./packages/defguard-client.nix {};
        };
        packages = forEachSystem (system: {
            defguard-client = pkgsBySystem.${system}.defguard-client;
            # default = pkgsBySystem.${system}.simple-go-server;
        });
        nixosModules = import ./modules {
            overlays = overlayList;
        };
    };
}
