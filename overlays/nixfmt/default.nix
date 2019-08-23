self: super: {
  nixfmt = (import (fetchTarball {
    url =
      "https://github.com/serokell/nixfmt/archive/4f827dfcbfe56967b2591e595a0404b65fd0fb69.tar.gz";
    sha256 = "08jz1islswvfijhij38zz80jg9pblbf1v4wj26jn6ap72g9gxa25";
  })) {
    pkgs = super;
    installOnly = true;
  };
}
