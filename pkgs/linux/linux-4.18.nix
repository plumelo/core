{ config, lib, pkgs, ... }:
let
  kernelConfig = import ./config.nix;
in {
  nixpkgs.overlays = [( self: super: {
    linux_testing_plumelo = super.callPackage <nixos/pkgs/os-specific/linux/kernel/linux-testing.nix> { 
      kernelPatches = with super; [  
        kernelPatches.bridge_stp_helper  
        kernelPatches.modinst_arg_list_too_long  
      ]; 
      argsOverride = with super; rec { 
        version = "4.18-rc5"; 
        modDirVersion = "4.18.0-rc5"; 
        src = fetchurl { 
          url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz"; 
          sha256 = "1r7ia0dc4p8xvyrl5kx9v7ii1m25ly0hg6xyz3zwhaailg1y4jzk"; 
        }; 
      }; 
    }; 
    linux_testing_slim = with kernelConfig; self.linux_testing_plumelo.override({
      ignoreConfigErrors= true;
      extraConfig =''
        CPU_SUP_CENTAUR n
        MK8 n
        MPSC n
        MATOM n
        CC_OPTIMIZE_FOR_PERFORMANCE y
        ${exclude.uncommon}
        ${exclude.fs}
        ${exclude.net}
        ${exclude.wlan}
      '';
    });

    linux_testing_gag3wifi = with kernelConfig; self.linux_testing_plumelo.override({
      ignoreConfigErrors= true;
      extraConfig =''
        CPU_SUP_CENTAUR n
        MK8 n
        MPSC n
        MATOM n
        CC_OPTIMIZE_FOR_PERFORMANCE y
        DRM_NOUVEAU n 
        DRM_I915 n 
        DRM_RADEON n
        DRM_AMDGPU_SI y
        DRM_AMDGPU_CIK y
        DRM_AMD_DC_PRE_VEGA y
        NR_CPUS 16 
        BT n  
        ${exclude.uncommon}
        ${exclude.fs}
        ${exclude.net}
        ${exclude.wlan}
      '';
    });

    linux_testing_yoga2pro = with kernelConfig; self.linux_testing_plumelo.override({
      ignoreConfigErrors= true;
      extraConfig =''
        CPU_SUP_AMD n
        CPU_SUP_CENTAUR n
        CC_OPTIMIZE_FOR_PERFORMANCE y
        NR_CPUS 8
        MCORE2 y
        MK8 n
        MPSC n
        MATOM n
        BT n
        DRM_NOUVEAU n
        DRM_RADEON n
        DRM_AMDGPU n
        ${exclude.uncommon}
        ${exclude.fs}
        ${exclude.net}
        ${exclude.wlan}
      '';
    });

    linuxPackages_plumelo   = super.linuxPackagesFor self.linux_testing_plumelo; 
    linuxPackages_slim      = super.linuxPackagesFor self.linux_testing_slim;
    linuxPackages_gag3w     = super.linuxPackagesFor self.linux_testing_gag3wifi;
    linuxPackages_yoga2pro  = super.linuxPackagesFor self.linux_testing_yoga2pro;
  })];
}
