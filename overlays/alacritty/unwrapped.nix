self: super:

with super;
with rustPlatform;

let
  rpathLibs = with xorg; [
    expat
    freetype
    fontconfig
    libX11
    libXcursor
    libXxf86vm
    libXrandr
    libGL
    libXi
  ];
in buildRustPackage rec {
  name = "alacritty-${version}";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "jwilm";
    repo = "alacritty";
    rev = "55c894b30be46d4dcc59ce78f357f2b55ef20bb0";
    sha256 = "17802fgfkp80872wr6qkjhs3gdjjw2cibigcifqnzcfzwabp07iv";
  };

  cargoSha256 = "0adw5zwxy1x9laa1fx11j2bhhs2w7c9n0xnjwxw8vchqi4xwqvy5";

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkgconfig
    ncurses
    gzip
  ];

  buildInputs = rpathLibs;

  outputs = [ "out" "terminfo" ];

  postPatch = ''
    substituteInPlace copypasta/src/x11.rs \
      --replace Command::new\(\"xclip\"\) Command::new\(\"${xclip}/bin/xclip\"\)
  '';

  installPhase = ''
    runHook preInstall

    install -D target/release/alacritty $out/bin/alacritty

    install -D alacritty.desktop $out/share/applications/alacritty.desktop
    patchelf --set-rpath "${stdenv.lib.makeLibraryPath rpathLibs}" $out/bin/alacritty

    install -D alacritty-completions.zsh "$out/share/zsh/site-functions/_alacritty"
    install -D alacritty-completions.bash "$out/etc/bash_completion.d/alacritty-completions.bash"
    install -D alacritty-completions.fish "$out/share/fish/vendor_completions.d/alacritty.fish"

    install -dm 755 "$out/share/man/man1"
    gzip -c alacritty.man > "$out/share/man/man1/alacritty.1.gz"

    install -dm 755 "$terminfo/share/terminfo/a/"
    tic -x -o "$terminfo/share/terminfo" alacritty.info
    mkdir -p $out/nix-support
    echo "$terminfo" >> $out/nix-support/propagated-user-env-packages

    runHook postInstall
  '';

  dontPatchELF = true;
}
