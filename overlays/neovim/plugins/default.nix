{ vimUtils, fetchFromGitHub, makeWrapper, callPackage }:
with vimUtils;
{
  nvim-typescript= callPackage ./nvim-typescript/default.nix {};

  ale = buildVimPluginFrom2Nix {
    pname = "ale";
    version = "2019-06-05";
    src = fetchFromGitHub {
      owner = "w0rp";
      repo = "ale";
      rev = "7b78f2b846e2f3443dcb2ceacee54eb99e37f040";
      sha256 = "1f6kldvcysa525xn6fnzg09chp39s63m7nxsq008lzykm30v00jr";
    };
  };

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

  yats = buildVimPlugin {
    pname= "yats-vim";
    version = "0.1";
    src = fetchFromGitHub {
      owner = "HerringtonDarkholme";
      repo = "yats.vim";
      rev = "80ae726dfdc87ef25df3225c35d8ba3fd10a36c0";
      sha256 = "12hhsqk9qrfqdaz1xkl3vqadk5hvyg5r6a8ydjvbvp1ykai7lqm8";
    };

    buildPhase = ":";
    configurePhase =":";
  };

  twig = buildVimPlugin {
    pname= "twig-vim";
    version = "0.1";
    src = fetchFromGitHub {
      owner = "lumiliet";
      repo = "vim-twig";
      rev = "ad115512725bcc156f7f89b72ff563b9fa44933b";
      sha256 = "1p7sfhk0mwx4xk88b29ijb9nfbjwsf6hf3nab2ybcw291qaa75nj";
    };

    buildPhase = ":";
    configurePhase =":";
  };

  jsx = buildVimPlugin {
    pname= "jsx-vim";
    version = "0.1";
    src = fetchFromGitHub {
      owner = "neoclide";
      repo = "vim-jsx-improve";
      rev = "1567a5e684676012e93ed5d44ee52a9818b970dc";
      sha256 = "1qzlfrhyvfy0vc8fpcam134axqdhhw0mx7vpib630zi0mqjh5h46";
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

