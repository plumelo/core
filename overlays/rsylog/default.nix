self: super:
with super; {
  rsyslog-full = rsyslog.overrideAttrs (old: rec {
    configureFlags = old.configureFlags ++ [ "--enable-mmdblookup" ];
    buildInputs = old.buildInputs ++ [ libmaxminddb ];
  });
}
