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
          "inode/directory"
          "x-directory/normal"
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
            "x-portable-pixmap"
            "x-portable-bitmap"
            "x-targa"
            "x-portable-greymap"
            "svg+xml"
            "svg-xml"
          ]
          ++ ([
            "application/pcx"
          ]);

        ## other ###
        "guitarpro" = builtins.map (s: "application/" + s) [
          "gpx"
          "x-gpx"
          "x-gpt"
          "x-guitarpro"
          "x-guitar-pro"
          "x-gnuplot"
        ];
      };
    in
    {
      enable = true;
      associations.added = associations;
      defaultApplications = associations;
    };
}
