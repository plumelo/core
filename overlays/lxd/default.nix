self: super:
{
  lxc = with super; lxc.overrideAttrs(old: rec {
    name = "lxc-${version}";
    version = "3.1.0";

    src = fetchurl {
      url = "https://linuxcontainers.org/downloads/lxc/lxc-${version}.tar.gz";
      sha256 = "1igxqgx8q9cp15mcp1y8j564bl85ijw04jcmgb1s5bmfbg1751sd";
    };
  });

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

  lxd = with super; lxd.overrideAttrs(old: rec {
    name = "lxd-${version}";
    version = "3.9";

    src = fetchurl {
      url = "https://github.com/lxc/lxd/releases/download/lxd-${version}/lxd-${version}.tar.gz";
      sha256 = "0zv0bzpb44md5d8y3i2i6srmcdzbzk87mw5byvzmd2s9931g4ip4";
    };
  });
}
