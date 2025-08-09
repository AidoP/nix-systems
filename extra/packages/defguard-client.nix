{
    cargo-tauri_1,
    fetchFromGitHub,
    fetchNpmDeps,
    glib-networking,
    gtk3,
    lib,
    libayatana-appindicator,
    moreutils,
    nodejs,
    perl,
    pnpm_9,
    openssl,
    pkg-config,
    protobuf,
    rustPlatform,
    stdenv,
    jq,
    webkitgtk_4_0,
    wrapGAppsHook4,
    breakpointHook,

    # The subdirectory of `target/` from which to copy the build artifacts
    targetSubdirectory ? stdenv.hostPlatform.rust.cargoShortTarget,
}:

rustPlatform.buildRustPackage rec {
    pname = "defguard-client";
    version = "1.4.0";

    src = fetchFromGitHub {
        owner = "DefGuard";
        repo = "client";
        tag = "v${version}";
        hash = "sha256-iV1fOwzmdrRsGt58JKqSOBZYgkqrP4aDt/2Uvkk7xbc=";
        fetchSubmodules = true;
    };

    cargoHash = "sha256-VN6ALg/67KNzmlEG/v5eeVxdooYPQUg2P7cUvkhfb60=";

    # Set our Tauri source directory
    cargoRoot = "src-tauri";
    # And make sure we build there too
    buildAndTestSubdir = cargoRoot;

    pnpmDeps = pnpm_9.fetchDeps {
        inherit pname src version;
        fetcherVersion = 2;
        hash = "sha256-6kKGmqxnAbmWOKmzHhGeHWn0Vje7VN+I963NLEE6jhM=";
    };

    # Fix the bundle referring to the incorrect build output directory
    postPatch = ''
        tauriConf="src-tauri/tauri.conf.json"
        jq '.tauri.bundle.deb.files."/usr/sbin/defguard-service" = "../target/${targetSubdirectory}/release/defguard-service"' "$tauriConf" | sponge "$tauriConf"

        substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
            --replace "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
    '';

    nativeBuildInputs = [
        # Pull in our main hook
        cargo-tauri_1.hook

        perl
        jq
        moreutils

        # Setup npm
        nodejs
        pnpm_9.configHook
        protobuf
        # breakpointHook

        # Make sure we can find our libraries
        pkg-config
    ]
        ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook4 ];

    buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
        glib-networking # Most Tauri apps need networking
        openssl
        webkitgtk_4_0
        libayatana-appindicator
    ] ++ lib.optionals stdenv.hostPlatform.isLinux [
        gtk3
    ];

}
