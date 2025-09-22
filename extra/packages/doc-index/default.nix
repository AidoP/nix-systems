{
    lib,
    rustPlatform,
    stdenv,
    pkg-config,
    wayland,

    # The subdirectory of `target/` from which to copy the build artifacts
    targetSubdirectory ? stdenv.hostPlatform.rust.cargoShortTarget,
}:

rustPlatform.buildRustPackage rec {
    pname = "doc-index";
    version = "0.1.0";

    src = ./.;
    cargoLock = {
        lockFile = ./Cargo.lock;
    };

    # cargoHash = "sha256-VN6ALg/67KNzmlEG/v5eeVxdooYPQUg2P7cUvkhfb60=";

    nativeBuildInputs = [pkg-config];

    buildInputs = [wayland];

}
