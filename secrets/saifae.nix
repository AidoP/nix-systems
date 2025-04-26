{
    # trifuse.xyz CloudFlare Origin Certificate
    age.secrets."trifuse-xyz-cert" = {
        file = ./trifuse-xyz-cert.age;
        group = "trifuse-xyz";
        mode = "660";
    };
    age.secrets."trifuse-xyz-key" = {
        file = ./trifuse-xyz-key.age;
        group = "trifuse-xyz";
        mode = "660";
    };
    # CloudFlare Token for Dynamic DNS updates
    age.secrets."ddclient-trifuse-xyz-token" = {
        file = ./ddclient-trifuse-xyz-token.age;
    };
}
