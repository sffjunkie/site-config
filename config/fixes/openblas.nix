{
  config = {
    nixpkgs.overlays = [
      (final: prev: {
        openblas = prev.openblas.overrideAttrs {
          doCheck = !prev.stdenv.hostPlatform.isi686;
        };
      })
    ];
  };
}
