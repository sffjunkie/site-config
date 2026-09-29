{
  config = {
    nixpkgs.overlays = [
      (final: prev: {
        buildGo125Module = prev.buildGoModule;
      })
    ];
  };
}
