{
    description = "NixOS Full Configuration";
    inputs = {
        nixos-stable.url = "github:NixOS/nixpkgs/nixos-24.11-small";
    };
    outputs = inputs@{ nixos-stable, ... }: {
        nixosConfigurations = builtins.mapAttrs (
            hostname:
            value@{ ... }:
            import ./hosts/${hostname} {
                inherit nixos-stable;
                inherit hostname;
            }
        ) {
            "saifae" = { };
        };
    };
}
