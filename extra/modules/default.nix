{ overlays, defguard }: {
    overlayNixpkgsForThisInstance = { pkgs, ... }: {
        nixpkgs = {
            inherit overlays;
        };
    };

    defguard-client = defguard.nixosModules.default;
}
