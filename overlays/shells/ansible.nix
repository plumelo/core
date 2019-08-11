{ mkShell, ansible, ansible-completion }:

mkShell {
  buildInputs = [ ansible ];
  shellHook = ''
    export XDG_DATA_DIRS=${ansible-completion}/share/:$XDG_DATA_DIRS
  '';
}
