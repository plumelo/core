{ config, lib, pkgs, ... }:
{
  boot = {
    kernelPackages = lib.mkForce pkgs.linuxPackages_raven;
    kernelParams = [
      "acpi_backlight=vendor"
      "i8042.nopnp"
      "acpi_osi=!"
      "acpi_osi=Linux"
      "ivrs_ioapic[4]=00:14.0"
      "ivrs_ioapic[5]=00:00.2"
    ];
    blacklistedKernelModules = [
      "dell-laptop"
      "dell-smbios"
      "dell-wmi"
    ];
  };

  services.xserver.videoDrivers = ["amdgpu"];
}

