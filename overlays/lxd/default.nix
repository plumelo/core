self: super:
{
  lxc-templates = with super; stdenv.mkDerivation rec {
    name = "lxc-templates-${version}";
    version = "3.0.3";
    src = fetchFromGitHub {
      owner = "lxc";
      repo = "lxc-templates";
      rev = "lxc-templates-${version}";
      sha256 = "15ywjgaimvxwc7xk5f4s1k7d384vfs12bc1jywhxahgirjjqgw2l";
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
