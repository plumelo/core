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
      fzf.out
      xclip
      gnumake
      ntfs3g
      usbutils
      killall
      neomutt

      # monitoring
      python27Packages.glances
      htop

      # audio
      python35Packages.mps-youtube
      python35Packages.youtube-dl
      mpv
      mplayer
      cava

      # office
      libreoffice-fresh
      unoconv

      # browsers
      firefox
      chromium
      google-chrome
      chromedriver
      epiphany

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
      atom
      editorconfig-core-c
      vim
      vim-vint
      neovim
      python27Packages.yamllint

      # langs
      nodejs-8_x
      ruby

      # misc
      keepassxc
      taskwarrior
      transmission_gtk
      stress
      glmark2
      
      # git
      gitAndTools.tig
      git-lfs
      git
      gitkraken

      # configuration management
      vagrant
      redir
      bridge-utils
      ansible_2_6
      avocode
      distrobuilder

      #files
      filezilla
      ranger
      vifm

      # sway
      i3blocks
      pavucontrol
      imv
      mpg123
    ];
  };
}
