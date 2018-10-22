{ config, lib, pkgs, ... }:
{
  boot = {
    kernelPackages = lib.mkForce pkgs.linuxPackages_raven;
    kernelParams = [
      "acpi_backlight=vendor"
      "i8042.nopnp"
    ];
    blacklistedKernelModules = [
      "dell-laptop"
      "dell-smbios"
      "dell-wmi"
    ];
  };

  services.xserver.videoDrivers = ["amdgpu"];
}

