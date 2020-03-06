{ pkgs, fetchFromGitHub }:
let
  buildVimPlugin = pkgs.vimUtils.buildVimPluginFrom2Nix;
  pluginSrc = src: (import src) {
    inherit
      fetchFromGitHub
      ;
  };
in
{
  ale = buildVimPlugin {
    name = "ale";
    src = pluginSrc ./plugins/ale.nix;
  };
  vimfugitive = buildVimPlugin {
    name = "vim-fugitive";
    src = pluginSrc ./plugins/fugitive.nix;
  };
  dispatch = buildVimPlugin {
    name = "vim-dispatch";
    src = pluginSrc ./plugins/dispatch.nix;
  };
  sgureditorconfig = buildVimPlugin {
    name = "vim-editorconfig";
    src = pluginSrc ./plugins/vim-editorconfig.nix;
  };
  hlyank = buildVimPlugin {
    name = "hlyank.vim";
    src = pluginSrc ./plugins/hlyank.nix;
  };
  vim-async-grep = buildVimPlugin {
    name = "vim-async-grep";
    src = pluginSrc ./plugins/vim-async-grep.nix;
  };
  conflict-marker = buildVimPlugin {
    name = "conflict-marker.vim";
    src = pluginSrc ./plugins/conflict-marker.nix;
  };
  vim-smoothie = buildVimPlugin {
    name = "vim-smoothie";
    src = pluginSrc ./plugins/vim-smoothie.nix;
  };
  cmdline-completion = buildVimPlugin {
    name = "cmdline-completion";
    src = pluginSrc ./plugins/cmdline-completion.nix;
  };
  vim-pairify = buildVimPlugin {
    name = "vim-pairify";
    src = pluginSrc ./plugins/vim-pairify.nix;
  };
  xcode = buildVimPlugin {
    name = "vim-colors-xcode";
    src = pluginSrc ./plugins/vim-colors-xcode.nix;
  };
  lithtml = buildVimPlugin {
    name = "vim-html-template-literals";
    src = pluginSrc ./plugins/lithtml.nix;
  };
  vim-pug = buildVimPlugin {
    name = "vim-pug";
    src = pluginSrc ./plugins/vim-pug.nix;
  };
  vim-pug-complete = buildVimPlugin {
    name = "vim-pug-complete";
    src = pluginSrc ./plugins/vim-pug-complete.nix;
  };
  vim-fixjson = buildVimPlugin {
    name = "vim-fixjson";
    src = pluginSrc ./plugins/vim-fixjson.nix;
  };
}
