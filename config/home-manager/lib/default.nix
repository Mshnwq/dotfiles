# lib/default.nix
inputs: [
  inputs.bird-nix-lib.lib.overlay
  (final: prev: {
    nixgl = import ./nixgl-wrapper.nix { lib = final; };
  })
]
