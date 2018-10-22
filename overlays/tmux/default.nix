self: super: 
with super;
{
  tmuxPlugins = tmuxPlugins // (with tmuxPlugins; {
    prefix-highlight =  prefix-highlight.overrideAttrs (old: rec {
      src = fetchgit {
        url = "https://github.com/tmux-plugins/tmux-prefix-highlight";
        rev = "61e8293452083f41b1cf633be503e8abf0c494ba";
        sha256 = "11fwwhghhw05v8n2npq5mjnly3r193jrcp7ivyx9h73zyh6l41l7";
      };
    });

    resurrect = resurrect.overrideAttrs (old : rec {
      src = fetchgit {
        url = "https://github.com/tmux-plugins/tmux-resurrect";
        rev = "e5cbe54c7526e8b00cec4652f760d4b8cdb8fece";
        sha256 = "0q7yxqniqal15q64nzks2wsigpgp2lwg44z2n89cqg8gr3yknvc2";
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
