{ pkgs, ... }: {
  programs.lf = {
    enable = true;
    settings = {
      shell = "bash";
      shellopts = "-eu";
      ifs = "\n";
      scrolloff = 10;
      hidden = true;
      icons = true;
    };
    keybindings = {
      "<enter>" = "shell";
      x = "$$f";
      X = "!$f";
      o = "&xdg-open $f";
      f = ''$lf -remote "send $id select '$(fd | fzf -i)'"'';
    };
    commands = {
      open = ''
        ''${{
          case $(${ pkgs.file }/bin/file --mime-type $f -b) in
            text/* | */lfrc ) $EDITOR $fx;;
            *) for f in $fx; do $OPENER $f > /dev/null 2> /dev/null & done;;
          esac
        }}
      '';
    };
    previewer.source = pkgs.writeShellScript "lf-previewer" ''
      #!/bin/sh
      export COLORTERM=256color
      case "$1" in
        *.tar*) ${ pkgs.gnutar }/bin/tar tf "$1";;
        *.zip) ${ pkgs.unzip }/bin/unzip -l "$1";;
        *.rar) ${ pkgs.unrar }/bin/unrar l "$1";;
        *.pdf) pdftotext "$1" -;;
        *) bat --color always "$1";;
      esac
    '';
    previewer.keybinding = "i";
  };

  programs.bash.initExtra =
    ''
      export LF_ICONS="\
      di=:\
      fi=:\
      ln=:\
      or=:\
      ex=:\
      *.c=:\
      *.cc=:\
      *.clj=:\
      *.coffee=:\
      *.cpp=:\
      *.css=:\
      *.d=:\
      *.dart=:\
      *.erl=:\
      *.exs=:\
      *.fs=:\
      *.go=:\
      *.h=:\
      *.hh=:\
      *.hpp=:\
      *.hs=:\
      *.html=:\
      *.java=:\
      *.jl=:\
      *.js=:\
      *.json=:\
      *.lua=:\
      *.md=:\
      *.php=:\
      *.pl=:\
      *.pro=:\
      *.py=:\
      *.rb=:\
      *.rs=:\
      *.scala=:\
      *.ts=:\
      *.vim=:\
      *.cmd=:\
      *.ps1=:\
      *.sh=:\
      *.bash=:\
      *.zsh=:\
      *.fish=:\
      *.tar=:\
      *.tgz=:\
      *.arc=:\
      *.arj=:\
      *.taz=:\
      *.lha=:\
      *.lz4=:\
      *.lzh=:\
      *.lzma=:\
      *.tlz=:\
      *.txz=:\
      *.tzo=:\
      *.t7z=:\
      *.zip=:\
      *.z=:\
      *.dz=:\
      *.gz=:\
      *.lrz=:\
      *.lz=:\
      *.lzo=:\
      *.xz=:\
      *.zst=:\
      *.tzst=:\
      *.bz2=:\
      *.bz=:\
      *.tbz=:\
      *.tbz2=:\
      *.tz=:\
      *.deb=:\
      *.rpm=:\
      *.jar=:\
      *.war=:\
      *.ear=:\
      *.sar=:\
      *.rar=:\
      *.alz=:\
      *.ace=:\
      *.zoo=:\
      *.cpio=:\
      *.7z=:\
      *.rz=:\
      *.cab=:\
      *.wim=:\
      *.swm=:\
      *.dwm=:\
      *.esd=:\
      *.jpg=:\
      *.jpeg=:\
      *.mjpg=:\
      *.mjpeg=:\
      *.gif=:\
      *.bmp=:\
      *.pbm=:\
      *.pgm=:\
      *.ppm=:\
      *.tga=:\
      *.xbm=:\
      *.xpm=:\
      *.tif=:\
      *.tiff=:\
      *.png=:\
      *.svg=:\
      *.svgz=:\
      *.mng=:\
      *.pcx=:\
      *.mov=:\
      *.mpg=:\
      *.mpeg=:\
      *.m2v=:\
      *.mkv=:\
      *.webm=:\
      *.ogm=:\
      *.mp4=:\
      *.m4v=:\
      *.mp4v=:\
      *.vob=:\
      *.qt=:\
      *.nuv=:\
      *.wmv=:\
      *.asf=:\
      *.rm=:\
      *.rmvb=:\
      *.flc=:\
      *.avi=:\
      *.fli=:\
      *.flv=:\
      *.gl=:\
      *.dl=:\
      *.xcf=:\
      *.xwd=:\
      *.yuv=:\
      *.cgm=:\
      *.emf=:\
      *.ogv=:\
      *.ogx=:\
      *.aac=:\
      *.au=:\
      *.flac=:\
      *.m4a=:\
      *.mid=:\
      *.midi=:\
      *.mka=:\
      *.mp3=:\
      *.mpc=:\
      *.ogg=:\
      *.ra=:\
      *.wav=:\
      *.oga=:\
      *.opus=:\
      *.spx=:\
      *.xspf=:\
      *.pdf=:\
      "
    '';
}
