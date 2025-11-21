# programs/wine.nix
{
  inputs,
  pkgs,
  ...
}:
let
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
            name = old.pname;
            icon = old.pname;
            exec = ''env DISPLAY="" ${old.pname}'';
            desktopName = "foobar2000";
            comment = "Advanced Freeware Audio Player";
            categories = [
              "Music"
              "Audio"
              "Player"
            ];
          })
        ];
      });
in
{
  home.packages =
    with pkgs;
    [
      guitarpro
    ]
    ++ ([
      foobar2000
      # inputs.erosanix.packages.${pkgs.system}.microcap
    ]);

  # home.file.".local/bin/microcap".source = "${
  #   inputs.erosanix.packages.${pkgs.system}.microcap
  # }/bin/microcap";
}
