self: super:
with super;
{
  gnome-ssh-askpass3 = stdenv.mkDerivation rec {
    src = fetchurl {
      url = "mirror://openbsd/OpenSSH/portable/${openssh.name}.tar.gz";
      sha256 = "1b8sy6v0b8v4ggmknwcqx3y1rjcpsll0f1f8f4vyv11x4ni3njvb";
    };
  name = "gnome-ssh-askpass3-${version}";
  version = "0.0.1";
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [gnome3.gtk];
  sourceRoot = "openssh-7.9p1/contrib";
  buildPhase = ''
    make gnome-ssh-askpass3
  '';
  installPhase = ''
    mkdir -p $out/bin;
    mv gnome-ssh-askpass3 $out/bin
    '';
};
  # openssh.overrideAttrs (attrs: rec {
  #   native
  #   postBuild = ''
  #     pushd contrib
  #     make gnome-ssh-askpass3
  #     popd
  #     '';
  #   postInstall = attrs.postInstall + ''
  #     ls -al contrib
  #   '';
  # });
}
