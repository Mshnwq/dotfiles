{
  pkgs,
  config,
  ...
}:
{
  vial = {
    home.packages = with pkgs; [
      vial
    ];
  };

  kmonad = {
    home.packages = with pkgs; [
      kmonad
    ];

    # https://github.com/kmonad/kmonad/blob/master/keymap/tutorial.kbd
    # https://github.com/sunaku/enthium
    home.file.".config/kmonad/config.kbd".text = ''
      (defcfg
        input  (device-file "/dev/input/by-path/platform-i8042-serio-0-event-kbd")
        output (uinput-sink "KMonad output")
        fallthrough true
      )
      (defsrc
        grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
        tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
        caps a    s    d    f    g    h    j    k    l    ;    '    ret
        lsft z    x    c    v    b    n    m    ,    .    /    rsft
        lctl lmet lalt           spc            ralt rmet cmp  rctl
      )
      (deflayer enthium-left
        grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
        tab  z    y    o    u    ;    y    u    i    o    p    [    ]    \
        caps c    i    e    a    w    h    j    k    l    ;    '    ret
        lsft -    =    ,    .    /    n    m    ,    .    /    rsft
        lctl lmet lalt           spc            ralt rmet cmp  rctl
      )
    '';

    systemd.user.services."kmonad" = {
      Unit = {
        Description = "KMonad keyboard remapper";
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.kmonad}/bin/kmonad ${config.home.homeDirectory}/.config/kmonad/config.kbd";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
