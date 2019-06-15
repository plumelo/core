self: super:
with super;
{
  bashPackages = {
    vcprompt = with rustPlatform; buildRustPackage rec {
      name = "vcprompt";
      version = "0.2.0";
      src = fetchFromGitHub {
        owner = "sscherfke";
        repo = "rust-vcprompt";
        rev = "0bf0ff4a995e123fb037fea30e3f55616754afbf";
        sha256 = "031zf151791vlabnckmm98pln2jiby00xhcr5jbj939qsn42hkcn";
      };
      cargoSha256 = "0jacm96l1gw9nxwavqi1x4669cg6lzy9hr18zjpwlcyb3qkw9z7f";
    };
  };
}
