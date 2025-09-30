{
    description = "Extra Packages";
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05-small";
        defguard.url = "git+https://github.com/DefGuard/client?submodules=1&ref=4290cce2d17656936270b3512ece78f6b8c10374";
    };
    outputs = {
        self,
        defguard,
        nixpkgs,
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
                #defguard-client = defguard.packages.default;
                #defguard-client = final.callPackage ./packages/defguard-client.nix {};
            doc-index = final.callPackage ./packages/doc-index/default.nix {};
                #defguard-cli = final.callPackage ./packages/defguard-cli.nix {};
        };
        # packages = forEachSystem (system: {
        #     defguard-client = defguard.packages.${system}.default;
        #         #defguard-client = pkgsBySystem.${system}.defguard-client;
        #     doc-index = pkgsBySystem.${system}.doc-index;
        #         #defguard = defguard.${system}.default;
        #     # default = pkgsBySystem.${system}.simple-go-server;
        # });
        nixosModules = import ./modules {
                inherit defguard;
            overlays = overlayList;
        };
    };
}
