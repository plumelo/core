{ config, lib, pkgs, ... }: 
{ 
  nixpkgs.overlays = [( self: super: { 
    firmwareLinuxNonfree = with super; firmwareLinuxNonfree.overrideAttrs(old: rec {
      name = "firmware-linux-nonfree-${version}";
      version = "2018-08-27";

      src = fetchgit {
        url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
        rev = "fea76a04f25fd0a217c0d566ff5ff8f23ad3e648";
        sha256 = "1xy1s9vd7jny4hf4f1hzhlbnm0l4pnw7xycky0v6kfwlg5nnjii5";
      };
      outputHash = "1p1dkzclj718w7di81s6486dn5zw77c4i2qn63bvp9q4vid452hn";
    });

    mesa_drivers = (with super; mesa_drivers.overrideAttrs (attrs: rec {
      version = "18.0.5";
      name = "mesa-noglu-${version}";
      passthru = attrs.passthru // { inherit version; };

      src =  fetchurl {
        url = "https://mesa.freedesktop.org/archive/mesa-${version}.tar.xz";
        sha256 = "0szwqjr5x2q4r6gcwb862s18wl4s0z34w4rd0vr7isiasylbp1si";
      };
    })).drivers;

    xorg = with super; xorg // {
      xf86videoamdgpu = xorg.xf86videoamdgpu.overrideAttrs (attrs: rec {
        name = "xf86-video-amdgpu-18.0.1";
        src = fetchurl {
          url = mirror://xorg/individual/driver/xf86-video-amdgpu-18.0.1.tar.bz2;
          sha256 = "06v9a8dxbhzzkad2qawy8sixz37hf82rh73dwalkqfs0rcn6i13l";
        };
      });
    };
    libdrm = with super; libdrm.overrideAttrs (old: rec {
      name = "libdrm-2.4.94";
      src = fetchurl {
        url = "https://dri.freedesktop.org/libdrm/${name}.tar.bz2";
        sha256 = "1ghn3l1dv1rsp9z6jpmy4ryna1s8rm4xx0ds532041bnlfq5jg5p";
      };
    });
  })];
}
