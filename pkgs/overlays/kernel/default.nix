self: super:
let
  config = import ./config.nix;
  buildLinux = (cfg: super.buildLinux rec {
    version = "5.0.9";
    modDirVersion = "5.0.9";
    extraMeta.branch = "5.0";
    src = super.fetchurl {
      url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
      sha256 = "0n5s0nwk786qyzwkjs5sv0ldhi8wry6xrsy9vldxp17qbcvv2j07";
    };
    ignoreConfigErrors = true;
    extraConfig = cfg;
    kernelPatches = with super.kernelPatches; [
      bridge_stp_helper
      modinst_arg_list_too_long
    ];
  });

  slim = buildLinux (with config; ''
    ${ryzen}
    ${exclude.uncommon}
    ${exclude.fs}
    ${exclude.net}
    ${exclude.wlan}
  '');

in {
    linuxPackages_plumelo   = super.linuxPackagesFor super.buildLinux;
    linuxPackages_slim      = super.linuxPackagesFor slim;
}
