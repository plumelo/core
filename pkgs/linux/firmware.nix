{ config, lib, pkgs, ... }: 
{ 
  nixpkgs.overlays = [( self: super: { 
    firmwareLinuxNonfree = with super; firmwareLinuxNonfree.overrideAttrs(old: rec {
      name = "firmware-linux-nonfree-${version}";
      version = "2018-07-30";

      src = fetchgit {
        url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
        rev = "f1b95fe5a51830bb8c1712082de4279a042376b6";
        sha256 = "1qxilfc79xpmmrcdx4j1fs75kiyplr8b5a1mv35cdk9cv24i15ji";
      };
      outputHash = "0i03zqi6rqxscj3sbxxifsb1vbgriw5f87c8xxipc8lp3lprllxs";
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
  })];
}
