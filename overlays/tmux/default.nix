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
        rev = "e3f05dd34f396a6f81bd9aa02f168e8bbd99e6b2";
        sha256 = "0ffh0664bbpbv2v3nsdv7lxvy0k09ixkpgrw1vq2my6nb22nmj4m";
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
