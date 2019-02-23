self: super:
{
    firmwareLinuxNonfree = with super; firmwareLinuxNonfree.overrideAttrs(old: rec {
      name = "firmware-linux-nonfree-${version}";
      version = "2019-02-21";
      src = fetchgit {
        url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
        rev = "54b0a748c8966c93aaa8726402e0b69cb51cd5d2";
        sha256 = "0i8v08w54ib7xdscwb4qqkgkpxzjvvsjp2dndi3zr6k954hb4qwv";
      };
      outputHash = "13y8mvv5w11cjnk5zvj6rqz707dmxh85yaf28h9cyybkj3qldq9g";
    });

    xorg = with super; xorg // {
      xf86videoamdgpu = xorg.xf86videoamdgpu.overrideAttrs (attrs: rec {
        name = "xf86-video-amdgpu-18.1.0";
        src = fetchurl {
          url = mirror://xorg/individual/driver/xf86-video-amdgpu-18.1.0.tar.bz2;
          sha256 = "0wlnb929l3yqj4hdkzyxyhbaph13ac4villajgmbh66pa6xja7z1";
        };
      });
    };

}
