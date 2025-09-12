{
    description = "Extra Packages";
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05-small";
    };
    outputs = {
        self,
        nixpkgs,
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
            doc-index = final.callPackage ./packages/doc-index/default.nix {};
            defguard-cli = final.callPackage ./packages/defguard-cli.nix {};
        };
        packages = forEachSystem (system: {
            defguard-client = pkgsBySystem.${system}.defguard-client;
            doc-index = pkgsBySystem.${system}.doc-index;
            # default = pkgsBySystem.${system}.simple-go-server;
        });
        nixosModules = import ./modules {
            overlays = overlayList;
        };
    };
}
