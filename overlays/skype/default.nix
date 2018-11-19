self: super: 
{
  skypeforlinux = with super; skypeforlinux.overrideAttrs (old: rec { 
    version = "8.35.76.30";

    src = fetchurl {
      url = "https://repo.skype.com/deb/pool/main/s/skypeforlinux/skypeforlinux_${version}_amd64.deb";
      sha256 = "04vp5s55fpcfq3wb4pk3b08dql924w9wn56b859n9n711x3q5762";
    };
  });
}
