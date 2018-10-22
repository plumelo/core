self: super: 
{
  skypeforlinux = with super; skypeforlinux.overrideAttrs (old: rec { 
    version = "8.32.76.42";

    src = fetchurl {
      url = "https://repo.skype.com/deb/pool/main/s/skypeforlinux/skypeforlinux_${version}_amd64.deb";
      sha256 = "1zk7c20hky8va8k135kp1v71gb95fbpxap7brr9zy1il1y7qkj2p";
    };
  });
}
