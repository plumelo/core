self: super: 
with super;
{
  neovim = neovim.override {
    configure = {
      customRC = ''
        set runtimepath+=${fzf.out}/share/vim-plugins/fzf*/
        set runtimepath^=~/.config/nvim
        let &packpath=&runtimepath
        source ~/.config/nvim/init.vim
      '';
    };
  };
}
