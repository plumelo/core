self: super:
{
    firmwareLinuxNonfree = with super; firmwareLinuxNonfree.overrideAttrs(old: rec {
      name = "firmware-linux-nonfree-${version}";
      version = "2018-10-26";
      src = fetchgit {
        url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
        rev = "1baa34868b2c0a004dc595b20678145e3fff83e7";
        sha256 = "0x1dixh2065rrvxx1rb9yrnqq210ngf9rf8jmq5ladyji7q25r2g";
      };
      outputHash = "0smf15n6ijzazd5m6jdngdfq3q7540nysi5dd7fr7qxs4x5mr9jn";
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
