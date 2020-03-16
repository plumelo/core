{ lxc, fetchpatch }:
lxc.overrideAttrs (
  old: rec
  {
    patches = old.patches ++ [
      (
        fetchpatch {
          name = "fix-cgroups-init.patch";
          url = "https://patch-diff.githubusercontent.com/raw/lxc/lxc/pull/3109.diff";
          sha256 = "1jpskr58ih56dakp3hg2yhxgvmn5qidi1vzxw0nak9afbx1yy9d4";
        }
      )
    ];
  }
)
