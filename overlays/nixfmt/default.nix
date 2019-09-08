self: super: {
  nixfmt = (import (fetchTarball {
    url =
      "https://github.com/serokell/nixfmt/archive/921bbd3bb9c95cf2d677a8558b1a27fca6cee597.tar.gz";
    sha256 = "0x08xsjal6db95y1sxxinwv9ks2k6fayvg8435s6zqy7zq42jxm4";
  })) {
    pkgs = super;
    installOnly = true;
  };
}
