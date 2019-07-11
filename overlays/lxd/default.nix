self: super:
with super;
{
  lxc-templates = stdenv.mkDerivation rec {
    name = "lxc-templates-${version}";
    version = "3.0.4";
    src = fetchFromGitHub {
      owner = "lxc";
      repo = "lxc-templates";
      rev = "lxc-templates-${version}";
      sha256 = "1cgfxi6j28d92v7wl37wz17dw6rw1sg1j72pwh32h0nik5gdd1y5";
    };
    preConfigure = ''
      for file in $(find ./config -type f -name  "*.conf.in"); do
        substituteInPlace $file \
          --replace "@LXCTEMPLATECONFIG@/common.conf" ${lxc}/share/lxc/config/common.conf \
          --replace "@LXCTEMPLATECONFIG@/userns.conf" ${lxc}/share/lxc/config/userns.conf
      done
    '';
    postInstall = ''
        rm -rf $out/var
    '';
    nativeBuildInputs = [
      autoreconfHook pkgconfig
    ];
    buildInputs = [lxc];
  };
}
