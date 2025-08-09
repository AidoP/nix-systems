{ overlays }: {
    overlayNixpkgsForThisInstance = { pkgs, ... }: {
        nixpkgs = {
            inherit overlays;
        };
    };

    defguard-client = import ./defguard-client.nix;
}
