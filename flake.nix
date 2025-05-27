{
    description = "NixOS Full Configuration";
    inputs = {
        nixos-stable.url = "github:NixOS/nixpkgs/nixos-25.05-small";
        nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable-small";
        ragenix.url = "github:yaxitech/ragenix";
    };
    outputs = inputs@{ nixos-stable, nixos-unstable, ragenix, ... }: {
        nixosConfigurations = builtins.mapAttrs (
            hostname:
            value@{ ... }:
            import ./hosts/${hostname} {
                inherit nixos-stable;
                inherit nixos-unstable;
                inherit ragenix;
                inherit hostname;
            }
        ) {
            "saifae" = { };
            "wulfim" = { };
        };
    };
}
