{ stdenv
, kakoune
, kakoune-unwrapped
, kakounePlugins
, callPackage
, makeWrapper
, writeText
, rustPlatform
, fetchFromGitHub
, ag
, ripgrep
, editorconfig-core-c
, nixpkgs-fmt
, universal-ctags
, nodePackages
}:
with stdenv.lib;
let
  plugins = callPackage ./plugins {};
  kakoune = kakoune-unwrapped.overrideAttrs (
    odl: rec {
      postInstall = ''
        mkdir -p $out/share
        tic -x -o "$out/share/terminfo" ../contrib/tmux-256color.terminfo
      '';
    }
  );
  eslint-formatter-kakoune = fetchFromGitHub {
    owner = "Delapouite";
    repo = "eslint-formatter-kakoune";
    rev = "910ecf922d17a3f373e4f6cb441b4ec52c3ba035";
    sha256 = "02i67xcmw4z101r25sgwiyqjif25yd0i1bfmgz5vmd2vhfl4jdc3";
  };
  kak-lsp = rustPlatform.buildRustPackage rec {
    pname = "kak-lsp";
    version = "7.0.0";

    src = fetchFromGitHub {
      owner = "ul";
      repo = pname;
      rev = "17fc6a6573251a77811ec7e75bf3807e24277cbb";
      sha256 = "1ysidrb78y7i1d8db301mnjnxsc2s26wvqk6kgd0jzra744wvpnn";
    };

    cargoSha256 = "0045p58z9ai642wgf085d28ds5nchhv24p733018aaqds0qss2pr";
  };

in
{
  kak = stdenv.mkDerivation {
    name = "kakoune-configured-${getVersion kakoune}";
    nativeBuildInputs = [ makeWrapper ];
    kakrc = writeText "kakrc" ''
      # grep
      set-option global grepcmd 'rg -L --column'

      # tab completion
      hook global InsertCompletionShow .* %{ map window insert <tab> <c-n>; map window insert <s-tab> <c-p> }
      hook global InsertCompletionHide .* %{ unmap window insert <tab> <c-n>; unmap window insert <s-tab> <c-p> }

      # files
      define-command find -params 1 -shell-script-candidates %{ ag -g ${
    "''"
    } --ignore "$kak_opt_ignored_files" } %{ edit %arg{1} }
      map global user f ": find<space>" -docstring "Edit a file, searching from current directory"

      define-command -hidden find-relative %{exec ": edit<space>%sh{echo  $(dirname $kak_buffile)}/"}
      map global user e ": find-relative<ret>" -docstring "Edit a file, searching from current file's directory"

      map global user b ": b<space>" -docstring "Switch buffers"

      # editorconfig
      hook global WinCreate ^[^*]+$ %{editorconfig-load}

      # highlighters
      hook global WinCreate .* %{
        addhl window/number-lines number-lines -hlcursor
        addhl window/show-whitespaces show-whitespaces -tab '‣' -tabpad ' ' -lf ' ' -spc ' ' -nbsp '⍽'
        addhl window/show-matching show-matching
        add-highlighter global/ dynregex '%reg{/}' 0:+u
      }
      hook global ModeChange .*:normal %{
          set-face global PrimaryCursor      rgb:000000,rgb:ffffff+F
      }
      hook global ModeChange .*:insert %{
          set-face global PrimaryCursor      rgb:ffffff,rgb:005577+F
      }

      # lsp
      eval %sh{${kak-lsp}/bin/kak-lsp --kakoune -s $kak_session --config ${
    writeText "kak-lsp.toml" ''
      [language.tsx]
      filetypes = ["typescript"]
      roots = ["package.json", "tsconfig.json"]
      command = "typescript-language-server"
      args = ["--stdio"]
    ''
    }}
      hook global WinSetOption filetype=(javascript|typescript) %{
        lsp-enable-window
      }

      hook global BufSetOption filetype=(javascript|typescript) %{
        set-option buffer formatcmd "prettier --stdin-filepath='%val{buffile}'"
        set-option buffer lintcmd "eslint --c .eslintrc* -f ${eslint-formatter-kakoune}/index.js --stdin-filename '%val{buffile}' --stdin <"
      }

      hook global BufSetOption filetype=(scss) %{
        set-option buffer formatcmd "stylelint --fix --stdin-filename='%val{buffile}'"
      }

      hook global BufSetOption filetype=nix %{
        set-option buffer formatcmd "nixpkgs-fmt"
      }

      try %{ source .kakrc.local }
      try %{ source .kakrc.mine }
      # colorscheme
      colorscheme nord
    '';

    buildCommand = ''
      mkdir -p $out/bin
      mkdir -p $out/share/kak/autoload/plugins
      mkdir -p $out/share/kak/colors

      # symlink core
      ln -sfv ${kakoune}/share/kak/autoload/ $out/share/kak/autoload/core
      ln -sfv ${kakoune}/share/terminfo/ $out/share/terminfo
      ln -sfv ${kakoune}/share/kak/colors/ $out/share/kak/colors

      # config
      ln -sfv $kakrc $out/share/kak/kakrc

      # plugins
      ln -sfv ${kakounePlugins.kak-powerline}/share/kak/autoload/plugins/powerline $out/share/kak/autoload/plugins/powerline
      ln -sfv ${plugins.typescript}/share/kak/autoload/plugins/typescript $out/share/kak/autoload/plugins/typescript
      ln -sfv ${./nord.kak} $out/share/kak/colors/nord.kak

      makeWrapper ${kakoune}/bin/kak $out/bin/kak \
        --prefix PATH : ${
    makeBinPath [
      ag
      ripgrep
      editorconfig-core-c
      nixpkgs-fmt
      universal-ctags
      nodePackages.typescript-language-server
    ]
    } \
        --set XDG_CONFIG_HOME $out/share/
    '';
  };
}
