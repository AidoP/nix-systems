let
    saifae = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII9VgZlylS6AE+3gzah+YzKnoYg7ssfMTL1TpuR9E9/D";
in {
    "trifuse-xyz-cert.age".publicKeys = [ saifae ];
    "trifuse-xyz-key.age".publicKeys = [ saifae ];
    "ddclient-trifuse-xyz-token.age".publicKeys = [ saifae ];
}
