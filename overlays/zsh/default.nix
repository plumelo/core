self: super: 
with super;
{
  zshThemes = {
    pure = stdenv.mkDerivation rec {
        pname = "pure";
        version = "1.8.0";
        name = "zsh-pure-${version}";

        src = fetchFromGitHub {
          owner = "sindresorhus";
          repo = pname;
          rev= "a643cc38013b73aade05dcab16fa3ce744d10115";
          sha256 = "0yq469616g184frvq4flahxxmwky05w2akrcd813ikn0r3gyzla9";
        };

        buildInputs = [ zsh ];

        installPhase = ''
          chmod +x pure.zsh async.zsh
          patchShebangs .
          
          install -Dm0644 pure.zsh $out/share/zsh/site-functions/prompt_pure_setup
          install -Dm0644 async.zsh $out/share/zsh/site-functions/async
        '';
    };
    spaceship = stdenv.mkDerivation rec {
        pname = "spaceship-prompt";
        version = "3.9.0";
        name = "zsh-${pname}-${version}";

        src = fetchFromGitHub {
          owner = "denysdovhan";
          repo = pname;
          rev= "6e42f9d78a9fef0d3822d4e6b90d254ca05f1120";
          sha256 = "07zwkbw1k503mqxz3x8xb843m6qcwqcsfdm0fpvhwmlkk1dxns99";
        };

        buildInputs = [ zsh ];

        installPhase = ''
          chmod +x spaceship.zsh
          patchShebangs .
          mkdir -p $out $out/share/zsh/site-functions
          cp -av spaceship.zsh lib scripts sections $out
          ln -sf $out/spaceship.zsh $out/share/zsh/site-functions/prompt_spaceship_setup
        '';
    };
  };

  zshPlugins = {
    nix-shell = stdenv.mkDerivation rec {
        pname = "zsh-nix-shell";
        version = "unstable";
        name = "${pname}-${version}";

        src = fetchFromGitHub {
          owner = "chisui";
          repo = pname;
          rev= "dceed031a54e4420e33f22a6b8e642f45cc829e2";
          sha256 = "10g8m632s4ibbgs8ify8n4h9r4x48l95gvb57lhw4khxs6m8j30q";
        };

        buildInputs = [ zsh ];

        installPhase = ''
          patchShebangs .
          mkdir -p $out
          cp -av nix-shell.plugin.zsh scripts $out
        '';
    };
  };
}
