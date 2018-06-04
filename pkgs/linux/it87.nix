{ config, lib, pkgs, ... }: 
 
let 
  kernel = config.boot.kernelPackages.kernel; 
in { 
  nixpkgs.overlays = [( self: super: { 
    it87  = with super; stdenv.mkDerivation  rec { 
      name = "it87-${version}"; 
      version = "1.0"; 
      src = fetchFromGitHub { 
        owner = "groeck"; 
        repo = "it87"; 
        rev = "71826085db0fc343eac84d153018c6ee2b96629e"; 
        sha256 = "1cf6765q8na4fr7lxqcsi5q782nc8an98hipkbpgwial5hdl1lhc"; 
      }; 
      hardeningDisable = ["pic"]; 
     nativeBuildInputs = kernel.moduleBuildDependencies; 
 
      preBuild = '' 
          substituteInPlace Makefile --replace "\$(shell uname -r)" "${kernel.modDirVersion}"
          substituteInPlace Makefile --replace "/lib/modules" "${kernel.dev}/lib/modules"
          substituteInPlace Makefile  --replace depmod \#  
          substituteInPlace Makefile --replace '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/hwmon/" 
        ''; 
      preInstall = '' 
        mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/hwmon" 
      ''; 
    };
  })];
}
