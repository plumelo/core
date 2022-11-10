{ lib, buildGo118Package, fetchurl }:

buildGo118Package rec {
  pname = "lxd-agent";
  version = "5.7";
  src = fetchurl {
    url = "https://linuxcontainers.org/downloads/lxd/lxd-${version}.tar.gz";
    sha256 = "sha256-TZeF/VPrP4qRAVezJwQWtfypsxBJpnTrST0uDdw3WVI=";
  };
  goPackagePath = "github.com/lxc/lxd";

  ldflags = [ "-extldflags=-static" "-s" "-w" ];

  subPackages = [ "lxd-agent" ];

  preConfigure = ''
    export CGO_ENABLED=0
  '';

  meta = with lib; {
    description = "Agent allowing LXD to acces VM functionalities";
    homepage = "https://linuxcontainers.org/lxd/";
    license = licenses.asl20;
    maintainers = with maintainers; [ fpletz marsam astralbijection ];
    platforms = platforms.linux;
  };
}
