{vimUtils, fetchFromGitHub}:
with vimUtils;

{
  largefile = buildVimPlugin {
    pname= "largefile-vim";
    version = "5";
    src = fetchFromGitHub {
      owner = "PanagiotisS";
      repo = "LargeFile";
      rev = "76abe439fcd3ea9906935236ee3ef595479e037b";
      sha256 = "0ww5cf70znvi7pk5a23wkbrsxcazyg4ym02p1rrigcpdzj1syaiy";
    };
  };

  quickfix = buildVimPlugin {
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
  };

  starsearch = buildVimPlugin {
    pname= "starsearch-vim";
    version = "0.1";
    src = fetchFromGitHub {
      owner = "darfink";
      repo = "starsearch.vim";
      rev = "9b8cda1e628160c83846db5a30899a1a1ba5c1c9";
      sha256 = "1i1ygdqwhz4jqmz9lzjnx1a7s5chdqjsvgkmnd9x0s8ixqa41bpr";
    };
  };

  onehalfdark = buildVimPlugin {
    pname= "onehalfdark-vim";
    version = "0.0.1";
    src= ./onehalfdark.vim;

    unpackCmd = ''
      mkdir -p out/colors;
      ln -s $curSrc out/colors/onehalfdark.vim
      ls -al $curSrc
    '';

    buildPhase = ":";
    configurePhase =":";
  };
}

