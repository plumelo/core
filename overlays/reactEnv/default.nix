self: super:
with super;
let yarn-10_x = super.yarn.override { nodejs = nodejs-10_x; };
in {
  react = mkShell {
    inputsFrom = [ yarn-10_x ];
    buildInputs = [ yarn-10_x graphviz ];
    shellHook = ''
      export XDG_DATA_DIRS=${self.yarn_completions}/share/:$XDG_DATA_DIRS
    '';
  };
}
