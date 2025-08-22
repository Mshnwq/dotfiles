{ config, pkgs, lib, ... }: {
  home.packages = [
    pkgs.pywal16
  ];
  home.activation.linkWalTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "${config.xdg.configHome}/yazi"
    mkdir -p "${config.xdg.configHome}/kitty"
    mkdir -p "${config.xdg.configHome}/zathura"
    mkdir -p "${config.xdg.configHome}/waybar"
    mkdir -p "${config.xdg.configHome}/alacritty"
    mkdir -p "${config.xdg.configHome}/cava"
    mkdir -p "${config.xdg.configHome}/rofi"
    mkdir -p "${config.xdg.configHome}/rmpc/themes"
    mkdir -p "${config.xdg.configHome}/btop/themes"
    mkdir -p "${config.xdg.configHome}/k9s/skins"

    ln -sf "${config.xdg.cacheHome}/wal/custom-yazi.toml" "${config.xdg.configHome}/yazi/theme.toml"
    ln -sf "${config.xdg.cacheHome}/wal/custom-kitty.conf" "${config.xdg.configHome}/kitty/custom-kitty.conf"
    ln -sf "${config.xdg.cacheHome}/wal/colors-zathura" "${config.xdg.configHome}/zathura/zathurarc"
    ln -sf "${config.xdg.cacheHome}/wal/colors-waybar.css" "${config.xdg.configHome}/waybar/colors-waybar.css"
    ln -sf "${config.xdg.cacheHome}/wal/colors-alacritty.toml" "${config.xdg.configHome}/alacritty/colors-alacritty.toml"
    ln -sf "${config.xdg.cacheHome}/wal/custom-cava" "${config.xdg.configHome}/cava/config"
    ln -sf "${config.xdg.cacheHome}/wal/custom-rofi.rasi" "${config.xdg.configHome}/rofi/shared.rasi"
    ln -sf "${config.xdg.cacheHome}/wal/custom-rmpc.ron" "${config.xdg.configHome}/rmpc/themes/custom-rmpc.ron"
    ln -sf "${config.xdg.cacheHome}/wal/custom-btop.theme" "${config.xdg.configHome}/btop/themes/pywal.theme"
    ln -sf "${config.xdg.cacheHome}/wal/custom-k9s.yaml" "${config.xdg.configHome}/k9s/skins/pywal.yaml"

    ln -sf "${config.xdg.cacheHome}/wal/custom-dunstrc" "${config.xdg.configHome}/dots/config/dunstrc"

    mkdir -p "${config.xdg.dataHome}/icons"
    mkdir -p "$HOME/.build/cursors/dist"
    ln -sf "$HOME/.build/cursors/dist/catppuccin-mocha-pywal-cursors" \
      "${config.xdg.dataHome}/icons/catppuccin-mocha-pywal-cursors"
    mkdir -p ${config.xdg.cacheHome}/wal/cursors"
  '';

  home.file."$HOME/.build/cursors".source =
    pkgs.fetchFromGitHub {
      owner = "mshnwq";
      repo = "cursors";
      rev = "6032da3";
      hash = "sha256-/N4VGQzkr4rV6/C2Y3MPX3jqlNMUxdeBfpQNeH3p9E4=";
    };
}
