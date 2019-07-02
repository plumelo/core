self: super: {
  nixfmt = (import (fetchTarball {
    url =
    "https://github.com/serokell/nixfmt/archive/dbed3c31c777899f0273cb6584486028cd0836d8.tar.gz";
    sha256 = "0gsj5ywkncl8rahc8lcij7pw9v9214lk23wspirlva8hwyxl279q";
  })) { };
}
