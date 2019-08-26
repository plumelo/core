{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libuv
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "raft";
  version = "0.9.5";
  src = fetchFromGitHub {
    owner = "CanonicalLtd";
    repo = pname;
    rev = "v${version}";
    sha256 = "1q49f5mmv6nr6dxhnp044xwc6jlczgh0nj0bl6718wiqh28411x0";
  };
  nativeBuildInputs = [ autoreconfHook pkgconfig];
  propagatedBuildInputs = [libuv];
}
