self: super:
{
    firmwareLinuxNonfree = with super; firmwareLinuxNonfree.overrideAttrs(old: rec {
      name = "firmware-linux-nonfree-${version}";
      version = "2019-01-18";
      src = fetchgit {
        url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
        rev = "a8b75cac06f80dc1500ba385680ac5b5c1d1c4f8";
        sha256 = "118vnbc60vrrk50pw98qaasnb4qmi7k32cxf92pq75k8c3q0n8yz";
      };
      outputHash = "0dys5zwnf9gz2ps5172x3p0d3b6z60xfahqjf0g0myakdfy7i07b";
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
