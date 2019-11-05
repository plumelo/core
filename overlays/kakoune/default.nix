self: super:
with super;
with stdenv.lib;
let
  plugins = callPackage ./plugins { };
  kakoune = kakoune-unwrapped.overrideAttrs (odl: rec {
    src = fetchFromGitHub {
      repo = "kakoune";
      owner = "mawww";
      rev = "ec31d839724cfd0f8431c04509f1f1d2b5fa1290";
      sha256 = "1nrsj74gfa0axaakvvfyhvcm7khi9fs2akfb4w5hng8azkgdr416";
    };
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

      # editorconfig
      hook global WinCreate ^[^*]+$ %{editorconfig-load}

      # highlighters
      hook global WinCreate .* %{
        addhl window/wrap wrap
        addhl window/number-lines number-lines -hlcursor
        addhl window/show-whitespaces show-whitespaces -tab '‣' -tabpad '―' -lf ' ' -spc ' ' -nbsp '⍽'
        addhl window/show-matching show-matching
        show-trailing-whitespace-enable; face window TrailingWhitespace default,magenta
      }

      # fzf
      map global normal <c-p> ': fzf-mode<ret>'
      hook global ModuleLoaded fzf %{
        set-option global fzf_implementation "sk"
        set-option global fzf_file_command "fd --type file --follow --hidden --exclude .git"
        set-option global fzf_highlight_command "bat --style=numbers --color=always {}"
        set-option global fzf_preview_tmux_height '20%'
        set-option global fzf_sk_grep_command "rg -L --no-heading"
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

      # config
      ln -sfv $kakrc $out/share/kak/kakrc

      #plugins
      ln -sfv ${kakounePlugins.kak-fzf}/share/kak/autoload/plugins/fzf $out/share/kak/autoload/plugins/fzf
      ln -sfv ${kakounePlugins.kak-powerline}/share/kak/autoload/plugins/powerline $out/share/kak/autoload/plugins/powerline
      ln -sfv ${plugins.typescript}/share/kak/autoload/plugins/typescript $out/share/kak/autoload/plugins/typescript

      makeWrapper ${kakoune}/bin/kak $out/bin/kak \
        --prefix PATH : ${
          makeBinPath [
            skim
            fd
            ripgrep
            bat
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
