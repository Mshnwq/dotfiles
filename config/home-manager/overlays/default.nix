# overlays/default.nix
inputs: [
  inputs.nixgl.overlay
  inputs.nur.overlays.default
  # inputs.claude-code.overlays.default
  inputs.claude-desktop.overlays.default
  (import ./lmms.nix)
  # (import ./highlight.nix)
  (import ./yt-dlp.nix)
]
