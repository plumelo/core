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
        version = "3.7.0";
        name = "zsh-${pname}-${version}";

        src = fetchFromGitHub {
          owner = "denysdovhan";
          repo = pname;
          rev= "0f4f6840ffba60c1f8b3e329ff2ee5a69d48a983";
          sha256 = "11wxh9ifvg6pdcs9hh6ml4six70nifg2l6mbjfd65dmy74d5yys8";
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
