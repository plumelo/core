{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig}:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "libco";
  version = "19";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = pname;
    rev = "b8b70b0cf5d6c6521174001133bb4fde6cce761a";
    sha256 = "0wf6lhk72iq37h32s8sf373z45cls86rk66dsnq0d130s3clx93q";
  };
  nativeBuildInputs = [ pkgconfig ];
  makeFlags = [ "DESTDIR=$(out)"  "PREFIX=" ];
}
