self: super:
{
  plumelo = with self; buildEnv {
    name  = "plumelo";
    paths = [
      #general
      ag
      ripgrep
      fd
      p7zip
      unzip
      zip
      ctags
      unrar
      fzf
      xclip
      gnumake
      ntfs3g
      usbutils
      killall
      neomutt

      # monitoring
      htop

      # audio
      python35Packages.mps-youtube
      python35Packages.youtube-dl
      mpv
      mplayer
      cava

      # office
      #libreoffice-fresh
      #unoconv

      # browsers
      firefox
      chromium

      # communication
      slack
      skypeforlinux
      libnotify
      (weechat.override {configure = {availablePlugins, ...}: {
        plugins = with availablePlugins; [
          (python.withPackages (ps: with ps; [
            websocket_client
          ]))
        ];};
      })

      # accounting
      ledger

      # editors
      editorconfig-core-c
      vim
      vim-vint
      neovim
      python27Packages.yamllint

      # langs
      ruby

      # misc
      keepassxc
      transmission_gtk
      stress

      # git
      gitAndTools.tig
      git-lfs
      git
      gitkraken

      # configuration management
      vagrant
      redir
      bridge-utils
      ansible_2_7
      avocode
      distrobuilder

      #files
      ranger

      # sway
      pavucontrol
      imv
      mpg123
    ];
  };
}
