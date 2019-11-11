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
        rev = "0f0ec12e9218482de7cc41a02a958bb5ae99d26f";
        sha256 = "1m3jjggi30k60pwm52xg5dxq5wzqxx921y03cx1xszx0nqfkc8rn";
      };
    });
  });
}
