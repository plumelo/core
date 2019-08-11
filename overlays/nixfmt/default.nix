self: super: {
  nixfmt = (import (fetchTarball {
    url =
      "https://github.com/serokell/nixfmt/archive/6f24303823efe4aa71e452ef1d9d5b330894429a.tar.gz";
    sha256 = "1d8f3rblhpv6ill8r74s7iyqmpilcxbs6jpm0p7g0z01iv5czvzw";
  })) {
    pkgs = super;
    installOnly = true;
  };
}
