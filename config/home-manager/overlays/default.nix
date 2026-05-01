# overlays/default.nix
inputs: [
  inputs.nixgl.overlay
  inputs.nur.overlays.default
  (import ./lmms.nix)
  (import ./highlight.nix)
  (import ./yt-dlp.nix)
]
