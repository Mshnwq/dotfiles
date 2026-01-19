# programs/mime.nix
{
  lib,
  ...
}:
let
  flipAssocs =
    assocs:
    lib.pipe assocs [
      (lib.mapAttrsToList mapMimeListToXDGAttrs)
      lib.flatten
      lib.zipAttrs
    ];
  mapMimeListToXDGAttrs =
    prog:
    map (type: {
      "${type}" = "${prog}.desktop";
    });
in
{
  xdg.mimeApps =
    let
      associations = flipAssocs {
        ### FILE BROWSER ###
        "org.kde.dolphin" = [
          "x-directory/normal"
          "inode/directory"
        ];

        ### DOCUMENT VIEWER ###
        "org.pwmt.zathura" = builtins.map (s: "application/" + s) [
          "pdf"
          "epub"
          "mobi"
        ];

        ### IMAGE VIEWER ###
        "org.kde.gwenview" =
          builtins.map (s: "image/" + s) [
            "bmp"
            "gif"
            "jpeg"
            "jpg"
            "png"
            "tiff"
            "x-bmp"
            "x-pcx"
            "x-tga"
            "x-targa"
            "svg+xml"
            "svg-xml"
            "x-portable-pixmap"
            "x-portable-bitmap"
            "x-portable-greymap"
          ]
          ++ ([
            "application/pcx"
          ]);

        ## other ###
        "guitarpro" = builtins.map (s: "application/" + s) [
          "gpx"
          "x-gpx"
          "x-gpt"
          "x-gnuplot"
          "x-guitarpro"
          "x-guitar-pro"
        ];
      };
    in
    {
      enable = true;
      associations.added = associations;
      defaultApplications = associations;
    };
}
