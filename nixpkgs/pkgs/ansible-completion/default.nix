{}:
stdenv.mkDerivation rec {
  name = "yarn-completion";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "dysosmus";
    repo = "ansible-completion";
    rev = "7254afb781e5782ccbe78ba70df1e4ed845deef7";
    sha256 = "12zxv953q0hwddkc2sfxp6cx9c7ld2qcssv3qvfv17hw8f99wrik";
  };

  buildPhase = "";
  installPhase = ''
    completions="$out/share/bash-completion/completions"
    mkdir -p $completions
    for file in *-completion.bash
    do
      cp -av "$file" "$completions/''${file/-completion.bash}".bash
    done
  '';
}
