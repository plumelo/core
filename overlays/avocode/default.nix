self: super: 
with super;
{
  avocode = avocode.overrideAttrs(old: rec {
    name = "avocode-${version}";
    version = "3.6.6";

    src = fetchurl {
      url = "https://media.avocode.com/download/avocode-app/${version}/avocode-${version}-linux.zip";
      sha256 = "1sdamj5fyfyw6rgab3ravrk8fdbhyq1kjrjyzxwf8hclsqd1ay4a";
    };
  });
}
