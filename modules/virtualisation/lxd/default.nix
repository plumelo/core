{ config, options, lib, pkgs, ... }:
with lib;

let
  cfg = config.virtualisation.lxd;
in
{
  options = {
    virtualisation.lxd.useQemu = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable (mkMerge [
    { virtualisation.lxd.recommendedSysctlSettings = true; }

    (mkIf (config.networking.networkmanager.dns == "dnsmasq") {
      environment.etc."NetworkManager/dnsmasq.d/10-dns-lxd.conf".text = ''
        server=/lxd/10.0.4.1
      '';
    })

    (mkIf cfg.useQemu {
      boot.kernelModules = [ "vhost_vsock" ];
      systemd.services.lxd.path = with pkgs; [
        qemu_kvm
        qemu-utils
        e2fsprogs
        util-linux
        gptfdisk
        swtpm
        kmod
        (pkgs.callPackage ./lxd-agent.nix { })
        (stdenv.mkDerivation rec {
          name = "virtiofsd";
          buildCommand = ''
            mkdir -p $out/bin
            ln -s ${qemu_kvm}/libexec/virtiofsd $out/bin/
            ln -s ${qemu_kvm}/libexec/virtfs-proxy-helper $out/bin/
          '';
        })
      ];
      systemd.services.lxd.environment.LXD_OVMF_PATH = ./OVMF;
    })
  ]);
}
