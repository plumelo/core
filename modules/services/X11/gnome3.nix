{ config, lib, pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    (buildEnv {
      name="glib-bin";
      paths = [glib];
      pathsToLink = "/bin";
      extraOutputsToInstall = ["dev"];
    })
    arc-theme
    arc-icon-theme

    paper-icon-theme

    numix-cursor-theme
    numix-gtk-theme
    numix-icon-theme
    numix-icon-theme-circle
    numix-icon-theme-square	
    numix-sx-gtk-theme

    adapta-gtk-theme

    # disk utilities
    parted
    gptfdisk
    cryptsetup
    ntfs3g
  ];

  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "eurosign:e";

    displayManager.gdm.enable = true;
    desktopManager = {
      gnome3.enable = true;
      kodi.enable = true; 
    };
  };

  services.gnome3 = {
    gnome-documents.enable = false;
    gnome-user-share.enable = false;
    gnome-online-miners.enable = false;
    gnome-keyring.enable = true;
    gnome-disks.enable = true;
  };
}

