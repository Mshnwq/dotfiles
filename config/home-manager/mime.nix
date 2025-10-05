{ lib, ... }:
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
        # "org.kde.okular" = [
        "zathura" = [
          "application/pdf"
          "application/epub"
          "application/mobi"
        ];

        ### IMAGE VIEWER ###
        "org.kde.gwenview" = [
          "image/bmp"
          "image/gif"
          "image/jpeg"
          "image/jpg"
          "image/png"
          "image/tiff"
          "image/x-bmp"
          "image/x-pcx"
          "image/x-tga"
          "image/x-portable-pixmap"
          "image/x-portable-bitmap"
          "image/x-targa"
          "image/x-portable-greymap"
          "application/pcx"
          "image/svg+xml"
          "image/svg-xml"
        ];

      };
    in
    {
      enable = true;
      associations.added = associations;
      defaultApplications = associations;
    };
}
