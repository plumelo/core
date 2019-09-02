self: super: {
  nixfmt = (import (fetchTarball {
    url =
      "https://github.com/serokell/nixfmt/archive/9b178986e339f260d0c335aef6f4950327af85dc.tar.gz";
    sha256 = "1agzz8v6lpxjr1arfb6q00r1yk4nwyh8l3sd8zmdhvh2zckip6j9";
  })) {
    pkgs = super;
    installOnly = true;
  };
}
