self: super: {
  lm_sensors = with super; lm_sensors.overrideAttrs(old: rec {
    version = "3.5.0";
    name = "lm-sensors-${version}";
    src = fetchFromGitHub {
      owner = "lm-sensors";
      repo = "lm-sensors";
      rev = "e8afbda10fba571c816abddcb5c8180afc435bba";
      sha256 = "1mdrnb9r01z1xfdm6dpkywvf9yy9a4yzb59paih9sijwmigv19fj";
    };
    patches = [];
    # NIX_CFLAGS_COMPILE = toString (old.NIX_CFLAGS_COMPILE or "") + " -DDEFAULT_CONFIG_DIR=\"/etc/sensors.d\"";
  });
}
