self: super:
{
    firmwareLinuxNonfree = with super; firmwareLinuxNonfree.overrideAttrs(old: rec {
      name = "firmware-linux-nonfree-${version}";
      version = "2018-12-18";
      src = fetchgit {
        url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
        rev = "0f22c8527439eaaf5c3fcf87b31c89445b6fa84d";
        sha256 = "1ja7b5bsv5w0arycxx9rb3fph16xllpnvzbflzq7cziw9aqdcp7i";
      };
      outputHash = "0fv0lj52rwcmngavw95n3nmlpc2wmnm769vgzg4f42j4dh206c94";
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
