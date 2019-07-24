self: super:
with super;
let
  vagrant_completion = vagrant.overrideAttrs (old: {
    postInstall = old.postInstall + ''
      mkdir -p $out/share/bash-completion/completions/
      cp -av contrib/bash/completion.sh $out/share/bash-completion/completions/vagrant
    '';
  });
in {
  ansible_env = mkShell {
    buildInputs = [ vagrant_completion redir bridge-utils ansible_2_7 ];
    shellHook = ''
      export XDG_DATA_DIRS=${vagrant_completion}/share/:$XDG_DATA_DIRS
  '';
  };
}
