{ pkgs, ... }: {
  programs.alacritty.enable = true;
  programs.alacritty.settings = {
    colors = {
      primary = {
        background = "0x282A36";
        foreground = "0xF8F8F2";
      };
      cursor = {
        text = "0x282A36";
        cursor = "0xF8F8F2";
      };
      normal = {
        black = "0x21222C";
        red = "0xFF5555";
        green = "0x50FA7B";
        yellow = "0xF1FA8C";
        blue = "0xBD93F9";
        magenta = "0xFF79C6";
        cyan = "0x8BE9FD";
        white = "0xF8F8F2";
      };
      bright = {
        black = "0x6272A4";
        red = "0xFF6E6E";
        green = "0x69FF94";
        yellow = "0xFFFFA5";
        blue = "0xD6ACFF";
        magenta = "0xFF92DF";
        cyan = "0xA4FFFF";
        white = "0xFFFFFF";
      };
    };
    font = { size = 10; };
    window = {opacity = 0.95; };
    env = {
      TERM = "xterm-256color";
    };
  };
}