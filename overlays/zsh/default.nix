self: super:
with super;
{
  zshThemes = {
    spaceship = stdenv.mkDerivation rec {
        pname = "spaceship-prompt";
        version = "3.11.0";
        name = "zsh-${pname}-${version}";

        src = fetchFromGitHub {
          owner = "denysdovhan";
          repo = pname;
          rev= "d9f25e14e7bec4bef223fd8a9151d40b8aa868fa";
          sha256 = "0vl5dymd07mi42wgkh0c3q8vf76hls1759dirlh3ryrq6w9nrdbf";
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
          rev= "b2609ca787803f523a18bb9f53277d0121e30389";
          sha256 = "01w59zzdj12p4ag9yla9ycxx58pg3rah2hnnf3sw4yk95w3hlzi6";
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
