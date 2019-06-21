self: super:
let
  url = "https://github.com/serokell/nixfmt/archive/v0.1.0.tar.gz";
  nixfmt = ((import (builtins.fetchTarball url)) {});
in
{
  nixfmt = nixfmt;
}
