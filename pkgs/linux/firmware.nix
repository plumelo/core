{ config, lib, pkgs, ... }: 
{ 
  nixpkgs.overlays = [( self: super: { 
    firmwareLinuxNonfree = with super; firmwareLinuxNonfree.overrideAttrs(old: rec {
      name = "firmware-linux-nonfree-${version}";
      version = "2018-09-04";
      src = fetchgit {
        url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
        rev = "44d4fca9922a252a0bd81f6307bcc072a78da54a";
        sha256 = "0fkb18apv4skhcpasa9a7pn1yjbrqs5nflz1ngg428syigzvqw8j";
      };
      outputHash = "076960qhiz2gdzlnw29fmx3jk71ks4dgf2mfymdaj7d9frnns8mv";
    });

    # mesa_drivers = (with super; mesa_drivers.overrideAttrs (attrs: rec {
    #   version = "18.0.5";
    #   name = "mesa-noglu-${version}";
    #   passthru = attrs.passthru // { inherit version; };

    #   src =  fetchurl {
    #     url = "https://mesa.freedesktop.org/archive/mesa-${version}.tar.xz";
    #     sha256 = "0szwqjr5x2q4r6gcwb862s18wl4s0z34w4rd0vr7isiasylbp1si";
    #   };
    # })).drivers;

    xorg = with super; xorg // {
      xf86videoamdgpu = xorg.xf86videoamdgpu.overrideAttrs (attrs: rec {
        name = "xf86-video-amdgpu-18.1.0";
        src = fetchurl {
          url = mirror://xorg/individual/driver/xf86-video-amdgpu-18.1.0.tar.bz2;
          sha256 = "0wlnb929l3yqj4hdkzyxyhbaph13ac4villajgmbh66pa6xja7z1";
        };
      });
    };

    # libdrm = with super; libdrm.overrideAttrs (old: rec {
    #   name = "libdrm-2.4.94";
    #   src = fetchurl {
    #     url = "https://dri.freedesktop.org/libdrm/${name}.tar.bz2";
    #     sha256 = "1ghn3l1dv1rsp9z6jpmy4ryna1s8rm4xx0ds532041bnlfq5jg5p";
    #   };
    # });
  })];
}
