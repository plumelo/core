self: super: {
  brightnessctl = with super; brightnessctl.overrideAttrs(old: rec {
    makeFlags = [ "PREFIX=" "DESTDIR=$(out)" ];
    installTargets = [ "install" ];
    postPatch = ''
      substituteInPlace 90-brightnessctl.rules --replace /bin/ ${coreutils}/bin/
    '';
  });
}

