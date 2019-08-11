{ mkShell, python38, mpv, cava}:
mkShell {
  buildInputs = [
    (python38.withPackages (ps: with ps; [mps-youtube]))
    mpv
    cava
  ];
}
