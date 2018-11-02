self: super:
with super;
let devicons = fetchFromGitHub {
    owner = "alexanderjeurissen";
    repo = "ranger_devicons";
    rev = "1aa59d3dddb33755f2df065fa0f9339ac90425aa";
    sha256 = "14dh6gfhd3smgc59klanvr81l06k6vv07rn6ajmaabxcvrrc7lky";
  };
in {
  ranger = super.ranger.overrideAttrs (old: rec {
    patches = [
      ./plugins.patch
      ./mpv.patch
    ];
    preConfigure = old.preConfigure + ''
      # settings
      substituteInPlace ranger/config/rc.conf \
          --replace "set vcs_aware false" "set vcs_aware true"

      # plugins hook
      substituteInPlace ranger/core/main.py \
        --replace "__plugins__" "['ranger.plugins.devicons_linemode']"

      cp -av ${devicons}/*.py ranger/plugins

      substituteInPlace ranger/plugins/devicons_linemode.py \
        --replace "from devicons" "from ranger.plugins.devicons"

      substituteInPlace ranger/config/rc.conf \
        --replace "set preview_images_method w3m" "set preview_images_method mpv"

    '';
  });
}
