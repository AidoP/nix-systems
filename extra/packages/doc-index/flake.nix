{
    description = "Documentation listing tool.";
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05-small";
        utils.url = "github:numtide/flake-utils";
    };
    outputs = {
        self,
        nixpkgs,
        utils,
        ...
    }: utils.lib.eachDefaultSystem (system: let
        pkgs = import nixpkgs { inherit system; };
    in {
        devShell = pkgs.mkShell {
            buildInputs = with pkgs; [
                cargo
                rustc
                rustfmt
                rustPackages.clippy
                rust-analyzer
                wayland
            ];
            RUST_SRC_PATH = pkgs.rustPlatform.rustLibSrc;
        };
    });
}
