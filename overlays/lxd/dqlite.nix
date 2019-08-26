{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libuv, sqlite-replication, raft, libco
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "dqlite";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "CanonicalLtd";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wdc1w2gq5cl579799h7fa0676gf24rs3n8ldllh5zyaqrxz9a42";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  propagatedBuildInputs = [ libuv sqlite-replication raft libco];
}
