{ pkgs, ... }: {
  hardware = {
    pulseaudio.enable = true;
    opengl.extraPackages = with pkgs; [ libvdpau-va-gl vaapiVdpau ];
  };

  boot = {
    initrd.availableKernelModules = [ "hid-logitech-hidpp" ];
  };

  zramSwap = {
    algorithm = "zstd";
    enable = true;
    priority = 6;
  };
}
