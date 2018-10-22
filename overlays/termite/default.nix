self: super:
{
  termite = with super; termite.override {
    configFile = writeText "termite-config" (builtins.readFile ./config);
  };
}

