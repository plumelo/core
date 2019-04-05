{ buildVimPlugin, fetchFromGitHub }:

buildVimPlugin {
  pname= "starsearch-vim";
  version = "0.1";
  src = fetchFromGitHub {
    owner = "darfink";
    repo = "starsearch.vim";
    rev = "9b8cda1e628160c83846db5a30899a1a1ba5c1c9";
    sha256 = "1i1ygdqwhz4jqmz9lzjnx1a7s5chdqjsvgkmnd9x0s8ixqa41bpr";
  };
}
