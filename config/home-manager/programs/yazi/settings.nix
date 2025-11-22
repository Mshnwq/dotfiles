# programs/yazi/settings.nix
{
  ...
}:
{
  mgr = {
    show_hidden = false;
    show_symlink = true;
    scrolloff = 5;
  };
  preview = {
    wrap = "no";
    max_width = 800;
    max_height = 1200;
  };
  opener = {
    edit = [
      {
        run = "$EDITOR $@";
        desc = "$EDITOR";
        block = true;
        for = "unix";
      }
      {
        run = "nvim $@";
        desc = "neovim";
        block = true;
        for = "unix";
      }
    ];
    open = [
      {
        run = "qimgv $1";
        for = "unix";
        when = ''extension in ["jpeg", "png", "jpg"]'';
      }
      {
        run = "xdg-open $1";
        desc = "Open";
        for = "linux";
      }
      {
        run = "nvim $@";
        desc = "neovim";
        block = true;
        for = "unix";
      }
    ];
    reveal = [
      {
        run = ''xdg-open $(dirname "$1")'';
        desc = "Reveal";
        for = "linux";
      }
      {
        run = ''exiftool "$1"; echo "Press enter to exit"; read _'';
        block = true;
        desc = "Show EXIF";
        for = "unix";
      }
    ];
    extract = [
      {
        run = "ya pub extract --list $@";
        desc = "Extract here";
        for = "unix";
      }
    ];
    # WHY BROKEN?
    play = [
      {
        run = ''xdg-open "$1"'';
        desc = "Open";
        for = "linux";
      }
    ];
  };
}
