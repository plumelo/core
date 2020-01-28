self: super:
with super; {
  parsec-client = import (
    builtins.fetchurl {
      url =
        "https://raw.githubusercontent.com/nix-community/nur-combined/9d88b55f8bff858cfb5077f2505188b544c63bcd/repos/clefru/pkgs/parsecgaming/default.nix";
      sha256 = "1l7sbkfq3rhkbic1h2cs7bwb6zg30xqlfd2vcj9d3jysvz4hbss3";
    }
  ) { inherit (super) pkgs; };
}
