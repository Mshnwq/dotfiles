"""
https://github.com/kovidgoyal/kitty/discussions/4447#discussioncomment-3240635
"""

# pyright: reportMissingImports=false

from kitty.boss import get_boss
from kitty.fast_data_types import Screen, get_options
from kitty.tab_bar import DrawData, ExtraData, TabBarData, as_rgb, draw_title
from kitty.utils import color_as_int

opts = get_options()
color_cache = {}

RIGHT_SYMBOL = ""
LEFT_SYMBOL = ""
ICON_SYMBOL = "   "
RIGHT_MARGIN = ""


def _get_color(color_int: int) -> int:
    if color_int not in color_cache:
        color_cache[color_int] = as_rgb(color_int)
    return color_cache[color_int]


def _set_colors(screen: Screen, fg_color: int, bg_color: int) -> None:
    """Helper to set foreground and background colors."""
    screen.cursor.fg = _get_color(fg_color)
    screen.cursor.bg = _get_color(bg_color)


def _draw_status(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    index: int,
    is_last: bool,
) -> int:
    if index == get_boss().active_tab_manager.active_tab_idx + 1:
        _set_colors(
            screen,
            color_as_int(opts.active_tab_foreground),
            color_as_int(opts.active_tab_background),
        )
        screen.draw(RIGHT_SYMBOL)
        draw_title(draw_data, screen, tab, index)
        screen.draw(LEFT_SYMBOL)
    else:
        _set_colors(
            screen,
            color_as_int(opts.inactive_tab_foreground),
            color_as_int(opts.inactive_tab_background),
        )
        screen.draw(RIGHT_SYMBOL)
        draw_title(draw_data, screen, tab, index)
        screen.draw(LEFT_SYMBOL)
    if is_last:
        _set_colors(
            screen,
            color_as_int(opts.active_tab_foreground),
            color_as_int(opts.active_tab_background),
        )
        screen.draw(RIGHT_SYMBOL)
        screen.draw(ICON_SYMBOL)
        screen.draw(RIGHT_MARGIN)
    end = screen.cursor.x
    return end


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    _draw_status(
        draw_data,
        screen,
        tab,
        index,
        is_last,
    )
    return screen.cursor.x
