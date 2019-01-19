self: super: 
{
  gitkraken = with super; gitkraken.overrideAttrs(old: rec {
    name = "gitkraken-${version}";
    version = "4.2.0";

    src = fetchurl {
      url = "https://release.axocdn.com/linux/GitKraken-v${version}.deb";
      sha256 = "1r1pamwg830a18928jjfajcq2yiqvadbdvklh89dpdqk2529yha0";
    };
  });
}
