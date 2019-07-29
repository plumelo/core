self: super:
with super;
{
  ansible_env = mkShell {
    buildInputs = [ vagrant_completion redir bridge-utils ansible_2_7 ];
    shellHook = ''
      export XDG_DATA_DIRS=${vagrant}/share/:$XDG_DATA_DIRS
  '';
  };
}
