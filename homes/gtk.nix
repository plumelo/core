{ pkgs, ... }: {
  gtk = {
    enable = true;
    theme = { name = "Colloid-Dark"; package = pkgs.colloid-gtk-theme; };
    iconTheme = { name = "Colloid-Dark"; package = pkgs.colloid-icon-theme; };
  };

}
