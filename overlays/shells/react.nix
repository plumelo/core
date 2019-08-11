{ mkShell, nodejs-10_x, yarn, yarn-completion, graphviz }:
let yarn-10_x = yarn.override { nodejs = nodejs-10_x; };
in mkShell {
  inputsFrom = [ yarn-10_x ];
  buildInputs = [ yarn-10_x graphviz ];
  shellHook = ''
    export XDG_DATA_DIRS=${yarn-completion}/share/:$XDG_DATA_DIRS
  '';
}
