self: super:
with super;
with stdenv.lib;
let
  plugins = callPackage ./plugins { };
  kakoune = kakoune-unwrapped.overrideAttrs (odl: rec {
    src = fetchFromGitHub {
      repo = "kakoune";
      owner = "mawww";
      rev = "7438f23b9beddc42b6561fe8be3f953aff2f73b1";
      sha256 = "0sw89wqhbs641xqjwknxals8dbqj9mlp3l2za6xsw4alwx6hfnan";
    };
    postInstall = ''
      mkdir -p $out/share
      tic -x -o "$out/share/terminfo" ../contrib/tmux-256color.terminfo
    '';
  });
  eslint-formatter-kakoune = fetchFromGitHub {
    owner = "Delapouite";
    repo = "eslint-formatter-kakoune";
    rev = "910ecf922d17a3f373e4f6cb441b4ec52c3ba035";
    sha256 = "02i67xcmw4z101r25sgwiyqjif25yd0i1bfmgz5vmd2vhfl4jdc3";
  };
in {
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
        addhl window/wrap wrap
        addhl window/number-lines number-lines -hlcursor
        addhl window/show-whitespaces show-whitespaces -tab '‣' -tabpad '―' -lf ' ' -spc ' ' -nbsp '⍽'
        addhl window/show-matching show-matching
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
        set-option buffer lintcmd "eslint --fix -c .eslintrc* -f ${eslint-formatter-kakoune}/index.js --stdin-filename '%val{buffile}' --stdin <"
      }

      hook global BufSetOption filetype=nix %{
        set-option buffer formatcmd "nixfmt"
      }

      try %{ source .kakrc.local }
      try %{ source .kakrc.mine }
    '';

    buildCommand = ''
      mkdir -p $out/bin
      mkdir -p $out/share/kak/autoload/plugins

      # symlink core
      ln -sfv ${kakoune}/share/kak/autoload/ $out/share/kak/autoload/core
      ln -sfv ${kakoune}/share/terminfo/ $out/share/terminfo

      # config
      ln -sfv $kakrc $out/share/kak/kakrc

      # plugins
      ln -sfv ${kakounePlugins.kak-powerline}/share/kak/autoload/plugins/powerline $out/share/kak/autoload/plugins/powerline
      ln -sfv ${plugins.typescript}/share/kak/autoload/plugins/typescript $out/share/kak/autoload/plugins/typescript

      makeWrapper ${kakoune}/bin/kak $out/bin/kak \
        --prefix PATH : ${
          makeBinPath [
            ag
            ripgrep
            editorconfig-core-c
            nixfmt
            universal-ctags
            nodePackages.typescript-language-server
          ]
        } \
        --set XDG_CONFIG_HOME $out/share/
    '';
  };
}
