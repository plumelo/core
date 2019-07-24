self: super: {
  nixfmt = (import (fetchTarball {
    url =
    "https://github.com/serokell/nixfmt/archive/a5c055e95dfb560e39c3adacc79757022d305d9c.tar.gz";
    sha256 = "1ippahc85i8pz1yyf7bdfycrqkaqpdanv9nq5rn8dz9l2qsvn2px";
  })) { };
}
