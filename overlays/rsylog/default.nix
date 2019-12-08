self: super:
with super; {
  rsyslog = rsyslog.overrideAttrs (old: rec {
    configureFlags = old.configureFlags ++ [ "--enable-mmdblookup" ];
    buildInputs = old.buildInputs ++ [ libmaxminddb ];
  });
}
