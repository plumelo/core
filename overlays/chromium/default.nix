self: super:
with super;
{

  chromium = chromium.override {
    commandLineArgs = "--enable-native-gpu-memory-buffers --enable-gpu-rasterization --ignore-gpu-blacklist --enable-zero-copy";
  };
}
