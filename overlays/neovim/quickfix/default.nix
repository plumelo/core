{ buildVimPlugin, fetchFromGitHub }:

buildVimPlugin {
  pname= "quickfix-vim";
  version = "0.1";
  src = fetchFromGitHub {
    owner = "stefandtw";
    repo = "quickfix-reflector.vim";
    rev = "c76b7a1f496864315eea3ff2a9d02a53128bad50";
    sha256 = "02vb7qkdprx3ksj4gwnj3j180kkdal8jky69dcjn8ivr0x8g26s8";
  };

  buildPhase = ":";
  configurePhase =":";

}
