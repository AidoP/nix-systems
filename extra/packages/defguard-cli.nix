{
    fetchFromGitHub,
    lib,
# libsoup_2_4,
    openssl,
    pkg-config,
    rustPlatform,
    stdenv,
    protobuf,
breakpointHook,

    # The subdirectory of `target/` from which to copy the build artifacts
    targetSubdirectory ? stdenv.hostPlatform.rust.cargoShortTarget,
}:

rustPlatform.buildRustPackage rec {
    pname = "defguard-cli";
    version = "1.4.0";

    src = fetchFromGitHub {
        owner = "DefGuard";
        repo = "client";
        tag = "v${version}";
        hash = "sha256-iV1fOwzmdrRsGt58JKqSOBZYgkqrP4aDt/2Uvkk7xbc=";
        fetchSubmodules = true;
    };

    cargoHash = "sha256-VN6ALg/67KNzmlEG/v5eeVxdooYPQUg2P7cUvkhfb60=";

    # Crate is in a subdirectory
    sourceRoot = "source/src-tauri";
    cargoBuildFlags = [
        "--package=defguard-dg"
    ];
    cargoTestFlags = [
        "--package=defguard-dg"
    ];

    # OPENSSL_NO_VENDOR = true;

    nativeBuildInputs = [
        # Make sure we can find our libraries
        # perl
        pkg-config
        protobuf
        rustPlatform.cargoSetupHook
        rustPlatform.cargoCheckHook
    #breakpointHook
    ];

    buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
        # libsoup_2_4
        openssl
    ];

}
