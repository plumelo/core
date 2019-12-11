self: super:
with super; {
  gnome-ssh-askpass3 = stdenv.mkDerivation rec {
    src = openssh.src;
    name = "gnome-ssh-askpass3-${version}";
    version = "0.0.1";
    nativeBuildInputs = [ pkgconfig ];
    buildInputs = [ gnome3.gtk ];
    sourceRoot = "openssh-${openssh.version}/contrib";
    buildPhase = ''
      make gnome-ssh-askpass3
    '';
    installPhase = ''
      mkdir -p $out/bin;
      mv gnome-ssh-askpass3 $out/bin
    '';
  };
}
