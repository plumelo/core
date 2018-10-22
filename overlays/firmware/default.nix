self: super:
{
    firmwareLinuxNonfree = with super; firmwareLinuxNonfree.overrideAttrs(old: rec {
      name = "firmware-linux-nonfree-${version}";
      version = "2018-10-18";
      src = fetchgit {
        url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
        rev = "d87753369b82c5f362250c197d04a1e1ef5bf698";
        sha256 = "1z6wdpsami8pkwawxgn7wp7b474522ccc73pfg1cd20w8dl11klw";
      };
      outputHash = "01rp635vgqb01cprzajcq93bixdq749ikbd8yxidqs1n9wsdv15h";
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
