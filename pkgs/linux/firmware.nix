{ config, lib, pkgs, ... }: 
{ 
  nixpkgs.overlays = [( self: super: { 
    firmwareLinuxNonfree = with super; firmwareLinuxNonfree.overrideAttrs(old: rec {
      name = "firmware-linux-nonfree-${version}";
      version = "2018-07-28";

      src = fetchgit {
        url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
        rev = "7b5835fd37630d18ac0c755329172f6a17c1af29";
        sha256 = "111pk6867an94gqshbyrbghsn9pbzjhgswdcjwd4z7cl7ikh6q0p";
      };
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
