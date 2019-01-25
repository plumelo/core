self: super: 
{
  gitkraken = with super; gitkraken.overrideAttrs(old: rec {
    name = "gitkraken-${version}";
    version = "4.2.1";

    src = fetchurl {
      url = "https://release.axocdn.com/linux/GitKraken-v${version}.deb";
      sha256 = "07f9h3276bs7m22vwpxrxmlwnq7l5inr2l67nmpiaz1569yabwsg";
    };
  });
}
