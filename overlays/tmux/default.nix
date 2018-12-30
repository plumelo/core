self: super: 
with super;
{
  tmuxPlugins = tmuxPlugins // (with tmuxPlugins; {
    prefix-highlight =  prefix-highlight.overrideAttrs (old: rec {
      src = fetchgit {
        url = "https://github.com/tmux-plugins/tmux-prefix-highlight";
        rev = "8880f9c9c43cd57443e0272334d17fda9991f369";
        sha256 = "1y23qc9r6v184vs4hvqg788zv097nnlg3rr4lwwz7hdg5glfdgaj";
      };
    });

    resurrect = resurrect.overrideAttrs (old : rec {
      src = fetchgit {
        url = "https://github.com/tmux-plugins/tmux-resurrect";
        rev = "b020b2481e9365d5ac09f22033f2bb01a86c0f2e";
        sha256 = "0vzb8zd7k48sy34ynb3mzrwb9qnsvqs2cdmg9916nid7a27av017";
      };
    });

    tmux-theme = mkDerivation {
      pluginName = "tmux-theme";
      rtpFilePath = "theme.tmux";
      src = fetchgit {
        url = "https://github.com/dweidner/tmux-theme";
        rev = "4f2b81547f04d6ec44add2a1b5e05446b5c18fa8";
        sha256 = "0bj5r70lq11hzqgdicmhnvqhdcwzj5vpg8wz1qjpq9i2r79r18f0";
      };
    };

  });
}
