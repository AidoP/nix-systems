{
    cargo-tauri,
    fetchFromGitHub,
    fetchNpmDeps,
    glib-networking,
    gtk3,
    lib,
    libsoup_3,
    libayatana-appindicator,
    webkitgtk_4_1,
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
    wrapGAppsHook4,
breakpointHook,

    # The subdirectory of `target/` from which to copy the build artifacts
    targetSubdirectory ? stdenv.hostPlatform.rust.cargoShortTarget,
}:

rustPlatform.buildRustPackage rec {
    pname = "defguard-client";
    version = "1.5.0";

    src = fetchFromGitHub {
        owner = "DefGuard";
        repo = "client";
        tag = "v${version}";
        hash = "sha256-TtccRImrywAUjvaAjHiOG6SBZ5Mgm6ksfJypN4hjS64=";
        fetchSubmodules = true;
    };

    cargoHash = "sha256-KNSGf05ShZ9JAzxx+c5/n3pJSm/Uum2F59Sr0B8oCF4=";

    # Set our Tauri source directory
    cargoRoot = "src-tauri";
    buildType = "debug";
    # And make sure we build there too
    buildAndTestSubdir = cargoRoot;

    OPENSSL_NO_VENDOR = true;

    pnpmDeps = pnpm_9.fetchDeps {
        inherit pname src version;
        fetcherVersion = 2;
        hash = "sha256-7o3zziR3KPr/sguZTCWunMws3ME+aPB2jNsjgU0yYaU=";
    };

    # Fix the bundle referring to the incorrect build output directory
    postPatch = ''
        tauriConf="src-tauri/tauri.conf.json"
        jq '.bundle.linux.deb.files."/usr/sbin/defguard-service" = "../target/${targetSubdirectory}/${buildType}/defguard-service" | .bundle.linux.rpm.files."/usr/sbin/defguard-service" = "../target/${targetSubdirectory}/${buildType}/defguard-service"' "$tauriConf" | sponge "$tauriConf"

        substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
            --replace "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
    '';

    nativeBuildInputs = [
        # Pull in our main hook
        cargo-tauri.hook

        # perl
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
        libayatana-appindicator
        libsoup_3
        webkitgtk_4_1
    ] ++ lib.optionals stdenv.hostPlatform.isLinux [
        gtk3
    ];

}
