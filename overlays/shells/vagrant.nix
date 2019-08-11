{ mkShell, vagrant, bridge-utils, redir }:
mkShell {
  buildInputs = [ vagrant redir bridge-utils  ];
  shellHook = ''
    export XDG_DATA_DIRS=${vagrant}/share/:$XDG_DATA_DIRS
  '';
}
