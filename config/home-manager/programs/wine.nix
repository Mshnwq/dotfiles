# programs/wine.nix
{
  inputs,
  pkgs,
  ...
}:
let
  # https://github.com/NixOS/rfcs/pull/148
  # experimental Nix feature 'pipe-operators' is disabled;
  # add '--extra-experimental-features pipe-operators' to enable it
  # https://github.com/emmanuelrosa/erosanix/
  foobar2000 =
    inputs.erosanix.packages.${pkgs.stdenv.hostPlatform.system}.foobar2000.overrideAttrs
      (old: {
        installPhase = ''
          runHook preInstall
          cp $out/bin/.launcher $out/bin/.foobar2000-launcher
          rm $out/bin/.launcher
          ln -s $out/bin/.foobar2000-launcher $out/bin/${old.pname}
          runHook postInstall
        '';
        desktopItems = [
          (pkgs.makeDesktopItem {
            comment = "Advanced Freeware Audio Player";
            exec = ''env DISPLAY="" ${old.pname}'';
            desktopName = "foobar2000";
            name = old.pname;
            icon = old.pname;
            categories = [
              "Music"
              "Audio"
              "Player"
            ];
          })
        ];
      });
  # i dont know both ways even with nanogl only works on install, and none with DISPLAY
  guitarpro =
    inputs.erosanix.lib.${pkgs.stdenv.hostPlatform.system}.nanogl pkgs.guitarpro
      [ ];
in
{
  # to garbage collect
  # nix run github:emmanuelrosa/erosanix#mkwindowsapp-tools
  home.packages =
    with pkgs;
    [
      # need to run env DISPLAY="" nixGL guitarpro
      # TODO: broken
      # need to run nixGL guitarpro
      guitarpro # from /pkgs/;
    ]
    ++ ([
      foobar2000
      # guitarpro # from /pkgs/;
      # inputs.erosanix.packages.${pkgs.system}.microcap
    ]);
}
