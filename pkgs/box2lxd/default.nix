{ writeShellScriptBin, gnutar, virtualbox, utillinux, lxd }:
writeShellScriptBin "box2lxd" ''
  tmp_path=/tmp/box2lxd
  rm -rf $tmp_path
  mkdir $tmp_path
  ${gnutar}/bin/tar -zxf $1 --skip-old-file --totals -v --directory $tmp_path
  ${virtualbox}/bin/VBoxManage clonemedium $tmp_path/*.vmdk --format RAW $tmp_path/image.raw
  loop=$(${utillinux}/bin/losetup -f)
  ${utillinux}/bin/losetup -f -P $tmp_path/image.raw
  mkdir -p /mnt/box2lxd
  ${utillinux}/bin/mount "$loop"p2 /mnt/box2lxd
  rm -rf /mnt/box2lxd/var/cache
  rm -rf /mnt/box2lxd/etc/netplan/50-vagrant.yml
  ${lxd}/bin/lxd-p2c https://localhost:8443 $2 /mnt/box2lxd
  umount /mnt/box2lxd
  losetup -d "$loop"
  rm -rf /mnt/box2lxd
  rm -rf $tmp_path
''
