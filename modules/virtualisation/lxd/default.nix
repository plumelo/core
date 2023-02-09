{ config, options, lib, pkgs, ... }:
with lib;
let
  cfg = config.virtualisation.lxd;
  ovmf = (import
    (builtins.fetchTarball {
      url = "https://github.com/nixos/nixpkgs/archive/665bb90fc3f6c39cfb290ecc100b3433082e5d64.tar.gz";
      sha256 = "sha256:1kbypzr5mwmc42s61zgyk0xiiyf9kikmml1d4p4qdijkyr1j6n3y";
    })
    { system = pkgs.system; }
  ).OVMFFull.fd;
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
      systemd.services.lxd.environment.LXD_OVMF_PATH = with pkgs; (stdenv.mkDerivation rec {
        name = "ovmf-meta";
        buildCommand = ''
          mkdir -p $out
          cp ${ovmf}/FV/OVMF.fd $out/
          cp ${ovmf}/FV/OVMF_CODE.fd $out/
          cp ${ovmf}/FV/OVMF_VARS.fd $out/OVMF_VARS.fd
          cp ${ovmf}/FV/OVMF_VARS.fd $out/OVMF_VARS.ms.fd
        '';
      });
    })
  ]);
}

