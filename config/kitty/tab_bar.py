"""
https://github.com/kovidgoyal/kitty/discussions/4447#discussioncomment-3240635
"""

# pyright: reportMissingImports=false

from kitty.boss import get_boss
from kitty.fast_data_types import Screen, get_options
from kitty.tab_bar import DrawData, ExtraData, TabBarData, as_rgb, draw_title
from kitty.utils import color_as_int

opts = get_options()

RIGHT_SYMBOL = ""
LEFT_SYMBOL = ""
ICON_SYMBOL = "   "
RIGHT_MARGIN = ""


def get_active_tab_index() -> int:
    return get_boss().active_tab_manager.active_tab_idx + 1


def _draw_status(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    index: int,
    is_last: bool,
) -> int:
    if index == get_active_tab_index():
        screen.cursor.fg = as_rgb(color_as_int(opts.active_tab_background))
        screen.cursor.bg = as_rgb(color_as_int(opts.active_tab_foreground))
        screen.draw(LEFT_SYMBOL)
        screen.cursor.bg = as_rgb(color_as_int(opts.active_tab_background))
        screen.cursor.fg = as_rgb(color_as_int(opts.active_tab_foreground))
        draw_title(draw_data, screen, tab, index)
        screen.cursor.fg = as_rgb(color_as_int(opts.active_tab_background))
        screen.cursor.bg = as_rgb(color_as_int(opts.active_tab_foreground))
        screen.draw(RIGHT_SYMBOL)
    else:
        screen.cursor.fg = as_rgb(color_as_int(opts.inactive_tab_background))
        screen.cursor.bg = as_rgb(color_as_int(opts.inactive_tab_foreground))
        screen.draw(LEFT_SYMBOL)
        screen.cursor.bg = as_rgb(color_as_int(opts.inactive_tab_background))
        screen.cursor.fg = as_rgb(color_as_int(opts.inactive_tab_foreground))
        draw_title(draw_data, screen, tab, index)
        screen.cursor.fg = as_rgb(color_as_int(opts.inactive_tab_background))
        screen.cursor.bg = as_rgb(color_as_int(opts.inactive_tab_foreground))
        screen.draw(RIGHT_SYMBOL)
    if is_last:
        screen.cursor.fg = as_rgb(color_as_int(opts.active_tab_background))
        screen.cursor.bg = as_rgb(color_as_int(opts.active_tab_foreground))
        screen.draw(LEFT_SYMBOL)
        screen.cursor.bg = as_rgb(color_as_int(opts.active_tab_background))
        screen.cursor.fg = as_rgb(color_as_int(opts.active_tab_foreground))
        screen.draw(ICON_SYMBOL)
        screen.cursor.fg = as_rgb(color_as_int(opts.active_tab_foreground))
        screen.cursor.bg = as_rgb(color_as_int(opts.active_tab_foreground))
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
