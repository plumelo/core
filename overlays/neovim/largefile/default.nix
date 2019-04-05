{ buildVimPlugin, fetchFromGitHub }:

buildVimPlugin {
  pname= "largefile-vim";
  version = "5";
  src = fetchFromGitHub {
    owner = "PanagiotisS";
    repo = "LargeFile";
    rev = "76abe439fcd3ea9906935236ee3ef595479e037b";
    sha256 = "0ww5cf70znvi7pk5a23wkbrsxcazyg4ym02p1rrigcpdzj1syaiy";
  };
}
