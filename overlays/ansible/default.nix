self: super: {

  ansible_27_p3 = with super; python3.pkgs.buildPythonPackage rec {
    pname = "ansible";
    version ="2.7.5";

    outputs = [ "out" "man" ];

    src = fetchurl {
      url = "https://releases.ansible.com/ansible/${pname}-${version}.tar.gz";
    sha256  = "1fsif2jmkrrgiawsd8r6sxrqvh01fvrmdhas0p540a6i9fby3yda";
    };

    prePatch = ''
      sed -i "s,/usr/,$out," lib/ansible/constants.py
    '';

    postInstall = ''
      wrapPythonProgramsIn "$out/bin" "$out $PYTHONPATH"
      for m in docs/man/man1/*; do
        install -vD $m -t $man/share/man/man1
      done
    '';

    doCheck = false;
    dontStrip = true;
    dontPatchELF = true;
    dontPatchShebangs = false;

    propagatedBuildInputs = with python3.pkgs; [
      pycrypto paramiko jinja2 pyyaml httplib2 boto six netaddr dnspython jmespath dopy
    ];

    meta = with stdenv.lib; {
      homepage = http://www.ansible.com;
      description = "A simple automation tool";
      license = with licenses; [ gpl3 ] ;
      maintainers = with maintainers; [ jgeerds joamaki ];
      platforms = with platforms; linux ++ darwin;
    };
  };
}
