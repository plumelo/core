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
  });
}
