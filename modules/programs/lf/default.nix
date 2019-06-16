{ config, lib, pkgs, ... }:
with pkgs;
let lf-preview = writeShellScriptBin "lf-preview" ''
  export COLORTERM=256color
  case "$1" in
    *.tar*) ${gnutar}/bin/tar tf "$1";;
    *.zip) ${unzip}/bin/unzip -l "$1";;
    *.rar) ${unrar}/bin/unrar l "$1";;
    *.7z) ${p7zip}/bin/7z l "$1";;
    *.pdf) pdftotext "$1" -;;
    *) ${bat}/bin/bat --color always --terminal-width=$2 --theme OneHalfDark "$1";;
  esac
'';
in {
  environment.etc."lf/lfrc".text = ''
    set shell bash
    set shellopts '-eu'
    set color256 on
    set ifs "\n"

    set scrolloff 10
    set hidden!
    set previewer '${lf-preview}/bin/lf-preview'

    map <enter> shell
    map x $$f
    map X !$f
    map o &mimeopen $f
    map O $mimeopen --ask $f

    cmd open ''${{
    case ''$(file --mime-type $f -b) in
      text/* | */lfrc ) $EDITOR $fx;;
      *) for f in $fx; do $OPENER $f > /dev/null 2> /dev/null & done;;
    esac
    }}

    cmd rename %[ -e $1 ] && printf "file exists" || mv $f $1
    map r push :rename<space>

    map <delete> delete

    cmd rename %[ -e $1 ] && printf "file exists" || mv $f $1

    cmd extract ''${{
    set -f
    case $f in
    *.tar.bz|*.tar.bz2|*.tbz|*.tbz2) ${gnutar}/bin/tar xjvf $f;;
    *.tar.gz|*.tgz) ${gnutar}/bin/tar xzvf $f;;
    *.tar.xz|*.txz) ${gnutar}/bin/tar xJvf $f;;
    *.zip) ${unzip}/bin/unzip $f;;
    *.rar) ${unrar}/bin/unrar x $f;;
    *.7z) ${p7zip}/bin/7z x $f;;
    esac
    }}

    cmd tar ''${{
    set -f
    mkdir $1
    cp -r $fx $1
    ${gnutar}/bin/tar czf $1.tar.gz $1
    rm -rf $1
    }}

    cmd zip ''${{
    set -f
    mkdir $1
    cp -r $fx $1
    ${gzip}/bin/zip -r $1.zip $1
    rm -rf $1
    }}

    map i ''${{BAT_PAGER="less -R" ${bat}/bin/bat $f}}

    cmd usage ''${{${coreutils}/bin/du -h -d1 | ${less}/bin/less}}

  '';
  environment.systemPackages = [lf];
}
