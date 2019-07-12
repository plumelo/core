self: super:
with super; {
  yarn_completions = stdenv.mkDerivation rec {
    name = "yarn-completions";
    version = "0.15.0";

    src = fetchFromGitHub {
      owner = "dsifford";
      repo = "yarn-completion";
      rev = "v${version}";
      sha256 = "1ziwribvagvvhxnbirz5n828b5v7h08gwryl2ck5myssnj6xhq3r";
    };

    buildPhase = "";
    installPhase = ''
      mkdir -p $out/share/bash-completion/completions/
      cp -av yarn-completion.bash "$out/share/bash-completion/completions/yarn"
    '';
  };
}
