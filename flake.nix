{
    description = "NixOS Full Configuration";
    inputs = {
        nixos-stable.url = "github:NixOS/nixpkgs/nixos-24.11-small";
        ragenix.url = "github:yaxitech/ragenix";
    };
    outputs = inputs@{ nixos-stable, ragenix, ... }: {
        nixosConfigurations = builtins.mapAttrs (
            hostname:
            value@{ ... }:
            import ./hosts/${hostname} {
                inherit nixos-stable;
                inherit ragenix;
                inherit hostname;
            }
        ) {
            "saifae" = { };
            "wulfim" = { };
        };
    };
}
