self: super: {
  lm_sensors = with super; lm_sensors.overrideAttrs(old: rec {
    src = fetchFromGitHub {
      owner = "groeck";
      repo = "lm-sensors";
      rev = "dcf23676cc264927ad58ae7960f518689372741a";
      sha256 = "0d0mcd6fcal9a36i5a40xi1g0p510lvh5bzlq6jdvkyrxa7wnhl2";
    };
    patches = [ ./config.patch ];
    NIX_CFLAGS_COMPILE = toString (old.NIX_CFLAGS_COMPILE or "") + " -DDEFAULT_CONFIG_DIR=\"/etc/sensors.d\"";
  });
}
