self: super:
with super;
{
  lazygit = lazygit.overrideAttrs (old: rec {
    name = "lazygit-${version}";
    version = "0.7.2";
    src = fetchFromGitHub {
      owner = "jesseduffield";
      repo = "lazygit";
      rev = "v${version}";
      sha256 = "1b5mzmxw715cx7b0n22hvrpk0dbavzypljc7skwmh8k1nlx935jj";
    };
  });
}
