{ stdenv
, kakoune
, kakoune-unwrapped
, kakounePlugins
, callPackage
, makeWrapper
, writeText
, fetchFromGitHub
, ag
, ripgrep
, wl-clipboard
, editorconfig-core-c
, nixpkgs-fmt
, universal-ctags
, nodePackages
, writeShellScript
, gnused
, nix
, kak-lsp
, lib
, ncurses
}:
with lib;
let
  plugins = callPackage ./plugins { };
  kakoune = kakoune-unwrapped.overrideAttrs
    (
      old: rec {
        postInstall = ''
          mkdir -p $out/share
          tic -x -o "$out/share/terminfo" ../contrib/tmux-256color.terminfo
        '' + old.postInstall;
        buildInputs = [ ncurses ];
      }
    );
  eslint-formatter-kakoune = fetchFromGitHub {
    owner = "Delapouite";
    repo = "eslint-formatter-kakoune";
    rev = "910ecf922d17a3f373e4f6cb441b4ec52c3ba035";
    sha256 = "02i67xcmw4z101r25sgwiyqjif25yd0i1bfmgz5vmd2vhfl4jdc3";
  };
  smarttab = fetchFromGitHub {
    owner = "andreyorst";
    repo = "smarttab.kak";
    rev = "1321c308edac6bd892e2bd2f683432402a04be98";
    sha256 = "048qq8aj405q3zm28jjh6ardxb8ixkq6gs1h3bwdv2qc4zi2nj4g";
  };
in
stdenv.mkDerivation {
  name = "kakoune-configured-${getVersion kakoune}";
  nativeBuildInputs = [ makeWrapper ];
  kakrc = writeText "kakrc" ''
    # colorscheme
    colorscheme nord

    # better defaults
    set-option global tabstop 2
    set-option global indentwidth 2
    set-option global grepcmd 'rg -L --column'
    set-option global startup_info_version 20420101
    set-option global ui_options ncurses_assistant=none
    set-option global autoreload true

    # tab completion
    hook global InsertCompletionShow .* %{ map window insert <tab> <c-n>; map window insert <s-tab> <c-p> }
    hook global InsertCompletionHide .* %{ unmap window insert <tab> <c-n>; unmap window insert <s-tab> <c-p> }

    # status
    define-command update-status %{ evaluate-commands %sh{
      printf %s 'set-option buffer modelinefmt %{'
      printf %s '{{context_info}} {{mode_info}} '
      printf %s ' · %val{bufname} [%opt{filetype}]'
      printf %s ' · %val{cursor_line}:%val{cursor_char_column}/%val{buf_line_count}'
      printf %s '}'
    }}
    hook global WinDisplay .* update-status

    # maps
    define-command find -params 1 -shell-script-candidates %{ ag --hidden --ignore .git -l -g "" } %{ edit %arg{1} }
    map global user f ": find<space>" -docstring "Edit a file, searching from current directory"

    define-command -hidden find-relative %{exec ": edit<space>%sh{echo  $(dirname $kak_buffile)}/"}
    map global user e ": find-relative<ret>" -docstring "Edit a file, searching from current file's directory"

    map global user b ": b<space>" -docstring "Switch buffers"

    map global normal '#' ': comment-line<ret>'

    # editorconfig
    hook global WinCreate ^[^*]+$ %{editorconfig-load}

    # highlighters
    hook global WinCreate .* %{
      addhl window/number-lines number-lines -hlcursor
      addhl window/show-whitespaces show-whitespaces -tab '‣' -tabpad ' ' -lf ' ' -spc ' ' -nbsp '⍽'
      addhl window/show-matching show-matching
    }
    hook global ModeChange .*:normal %{
      set-face global PrimaryCursor      rgb:000000,rgb:ffffff+F
    }
    hook global ModeChange .*:insert %{
      set-face global PrimaryCursor      rgb:ffffff,rgb:005577+F
    }
    hook global BufWritePre .* %{ nop %sh{ mkdir -p $(dirname "$kak_hook_param") }}

    # smarttab
    source ${smarttab}/rc/smarttab.kak
    hook global BufOpenFile .* %{ evaluate-commands -buffer %val(hook_param) %{ try %{
      execute-keys '%s^\t<ret>'
      set buffer indentwidth 0
      noexpandtab
    } catch %{
      expandtab
    }}}

    # cliboard
    map global user y '<a-|>${wl-clipboard}/bin/wl-copy > /dev/null 2>&1 <ret>' -docstring "Yank (system clipboard)"
    map global user P '!${wl-clipboard}/bin/wl-paste -n<ret>' -docstring "Paste before (system clipboard)"
    map global user p '<a-!>${wl-clipboard}/bin/wl-paste -n<ret>' -docstring "Paste after (system clipboard)"

    # lsp
    eval %sh{
      ${kak-lsp}/bin/kak-lsp --kakoune -s $kak_session --config ${writeText "kak-lsp.toml"
      ''
        [language.typescript]
        filetypes = ["typescript","javascript"]
        roots = ["package.json", "tsconfig.json"]
        command = "typescript-language-server"
        args = ["--stdio"]
      ''}
    }
    hook global WinSetOption filetype=(javascript|typescript) %{
      lsp-enable-window
    }

    hook global BufSetOption filetype=(javascript|typescript) %{
      set-option buffer formatcmd "prettier --stdin-filepath='%val{buffile}'"
      set-option buffer lintcmd "eslint --c .eslintrc* -f ${eslint-formatter-kakoune}/index.js --stdin-filename '%val{buffile}' --stdin <"
      define-command -override eslint-fix %{ nop %sh{ eslint --fix $kak_buffile }}
    }

    hook global BufSetOption filetype=(scss) %{
      set-option buffer formatcmd "stylelint --fix --stdin-filename='%val{buffile}'"
    }

    hook global BufSetOption filetype=nix %{
      set-option buffer formatcmd "nixpkgs-fmt"
      set-option buffer lintcmd "${
      writeShellScript "kaknix" ''
        if [ ''$# -ne 1 ] || [ ! -f "$1"  ]; then
          exit 1
        fi
        ${nix}/bin/nix-instantiate --parse "$1" 2>&1 >&- | ${gnused}/bin/sed 's/^\(.\+\), at \(.\+\)$/\2: \1/'
      ''
    }"
    }

    try %{ source .kakrc.local }
    try %{ source .kakrc.mine }

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
    ln -sfv ${plugins.typescript}/share/kak/autoload/plugins/typescript $out/share/kak/autoload/plugins/typescript
    ln -sfv ${./nord.kak} $out/share/kak/colors/nord.kak

    makeWrapper ${kakoune}/bin/kak $out/bin/kak \
      --prefix PATH : ${makeBinPath [
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
}
