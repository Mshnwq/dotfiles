"""Make Anki's main window see-through so Hyprland's wallpaper and blur show
behind it, instead of a wallpaper being painted inside the window.

Two halves have to agree or the window stays opaque:

* Qt side -- the QMainWindow must not fill its own background, and each
  QWebEngineView needs an alpha-0 page colour. Anki sets that colour from
  ``colors.CANVAS`` in ``AnkiWebView.__init__`` and again on every theme
  change, so it is re-applied here after ``theme_did_change``.
* Web side -- Anki's generated stylesheet ends with
  ``body { background-color: var(--canvas) }``, which would repaint the
  window opaque from inside the page.

Only the three main-window webviews are touched. Dialogs (browser, editor,
preferences) are ordinary opaque windows and keep the normal pywal canvas.
"""

from aqt import gui_hooks, mw
from aqt.qt import QColor, Qt

# The colour left behind the page. Fully transparent means the compositor's
# blurred wallpaper is what shows through; something like
# "rgba(5, 5, 11, 0.4)" instead tints it towards the pywal background.
BACKGROUND = "transparent"

TRANSPARENT = QColor(0, 0, 0, 0)

# Anki names its bundled stylesheets in WebContent.css; these are the ones
# used by pages that render inside the main window.
MAIN_WINDOW_CSS = {
    "webview.css",
    "deckbrowser.css",
    "overview.css",
    "reviewer.css",
    "reviewer-bottom.css",
    "toolbar.css",
    "toolbar-bottom.css",
    "congrats.css",
}

# .card is the reviewer's body class; note types commonly hard-code an opaque
# background there, so it needs overriding too.
STYLE = f"""
html, body {{ background: {BACKGROUND} !important; }}
.card {{ background: {BACKGROUND} !important; }}
"""


def _main_webviews():
    for attr in ("toolbarWeb", "web", "bottomWeb"):
        web = getattr(mw, attr, None)
        if web is not None:
            yield web


def _make_translucent() -> None:
    mw.setAttribute(Qt.WidgetAttribute.WA_TranslucentBackground, True)
    mw.setAutoFillBackground(False)
    central = getattr(mw.form, "centralwidget", None)
    if central is not None:
        central.setAttribute(Qt.WidgetAttribute.WA_TranslucentBackground, True)
        central.setAutoFillBackground(False)
    for web in _main_webviews():
        web.setAttribute(Qt.WidgetAttribute.WA_TranslucentBackground, True)
        web.page().setBackgroundColor(TRANSPARENT)


def _inject_css(web_content, context) -> None:
    names = {name.removeprefix("css/") for name in web_content.css}
    if names & MAIN_WINDOW_CSS:
        web_content.head += f"<style>{STYLE}</style>"


gui_hooks.webview_will_set_content.append(_inject_css)
gui_hooks.main_window_did_init.append(_make_translucent)
gui_hooks.theme_did_change.append(_make_translucent)
