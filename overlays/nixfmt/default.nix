self: super: {
  nixfmt = (import (fetchTarball {
    url =
    "https://github.com/serokell/nixfmt/archive/af09262aa7d08d2b0905b11d2e8958889aadcf46.tar.gz";
    sha256 = "0njgjv6syv3sk97v8kq0cb4mhgrb7nag2shsj7rphs6h5b7k9nbx";
  })) {
    pkgs = super;
    installOnly = true;
  };
}
