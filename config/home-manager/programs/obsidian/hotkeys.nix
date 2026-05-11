# programs/obsidian/hotkeys.nix
{
  ...
}:
{
  # clear ones with conflicts
  "editor:delete-paragraph" = [ ];
  "workspace:edit-file-title" = [
    {
      "modifiers" = [
        "Mod"
      ];
      "key" = "R";
    }
  ];
  "app:open-settings" = [
    {
      "modifiers" = [
        "Mod"
      ];
      "key" = "`";
    }
  ];
  "app:toggle-ribbon" = [
    {
      "modifiers" = [
        "Mod"
        "Alt"
      ];
      "key" = "S";
    }
  ];
  "markdown:toggle-preview" = [
    {
      "modifiers" = [
        "Mod"
      ];
      "key" = "Escape";
    }
  ];
  # just Alt Down when right side bar is focused
  "app:toggle-right-sidebar" = [
    {
      "modifiers" = [
        "Mod"
      ];
      "key" = "\\";
    }
  ];
  # Alt + []\ for top box tabs
  "backlink:open" = [
    {
      "modifiers" = [
        "Alt"
      ];
      "key" = "[";
    }
  ];
  "outgoing-links:open" = [
    {
      "modifiers" = [
        "Alt"
      ];
      "key" = "]";
    }
  ];
  "outline:open" = [
    {
      "modifiers" = [
        "Alt"
      ];
      "key" = "\\";
    }
  ];
  "workspace:split-vertical" = [
    {
      "modifiers" = [
        "Mod"
        "Shift"
      ];
      "key" = "\\";
    }
  ];
  "window:zoom-in" = [
    {
      "modifiers" = [
        "Mod"
      ];
      "key" = "=";
    }
  ];
  "window:zoom-out" = [
    {
      "modifiers" = [
        "Mod"
      ];
      "key" = "-";
    }
  ];
  "editor:toggle-fold-properties" = [
    {
      "modifiers" = [
        "Mod"
      ];
      "key" = ".";
    }
  ];
  "markdown:add-metadata-property" = [
    {
      "modifiers" = [
        "Mod"
      ];
      "key" = ",";
    }
  ];
  "open-with-default-app:open" = [
    {
      "modifiers" = [
        "Mod"
      ];
      "key" = ";";
    }
  ];
  "app:delete-file" = [
    {
      "modifiers" = [
        "Mod"
      ];
      "key" = "D";
    }
  ];
  "insert-template" = [
    {
      "modifiers" = [
        "Mod"
        "Alt"
      ];
      "key" = "T";
    }
  ];
  "workspace:new-tab" = [
    {
      "modifiers" = [
        "Mod"
      ];
      "key" = "T";
    }
  ];
  "editor:focus-left" = [
    {
      "modifiers" = [
        "Alt"
      ];
      "key" = "ArrowLeft";
    }
  ];
  "editor:focus-bottom" = [
    {
      "modifiers" = [
        "Alt"
      ];
      "key" = "ArrowDown";
    }
  ];
  "editor:focus-top" = [
    {
      "modifiers" = [
        "Alt"
      ];
      "key" = "ArrowUp";
    }
  ];
  "editor:focus-right" = [
    {
      "modifiers" = [
        "Alt"
      ];
      "key" = "ArrowRight";
    }
  ];
  "app:go-back" = [
    {
      "modifiers" = [
        "Mod"
      ];
      "key" = "O";
    }
  ];
  "app:go-forward" = [
    {
      "modifiers" = [
        "Mod"
        "Shift"
      ];
      "key" = "O";
    }
  ];
  "file-explorer:move-file" = [
    {
      "modifiers" = [
        "Mod"
      ];
      "key" = "M";
    }
  ];
  "graph:open-local" = [
    {
      "modifiers" = [
        "Mod"
        "Shift"
      ];
      "key" = "G";
    }
  ];
  "daily-notes" = [
    {
      "modifiers" = [
        "Mod"
      ];
      "key" = "Y";
    }
  ];
  "daily-notes:goto-next" = [
    {
      "modifiers" = [
        "Mod"
        "Shift"
      ];
      "key" = "Y";
    }
  ];
  "daily-notes:goto-prev" = [
    {
      "modifiers" = [
        "Alt"
        "Mod"
      ];
      "key" = "Y";
    }
  ];
  "workspace:copy-full-path" = [
    {
      "modifiers" = [
        "Mod"
      ];
      "key" = "P";
    }
  ];
  "command-palette:open" = [
    {
      "modifiers" = [
        "Shift"
      ];
      "key" = ";";
    }
  ];
  "jupymd:run-all-code-blocks" = [
    {
      "modifiers" = [
        "Mod"
      ];
      "key" = "J";
    }
  ];
  "jupymd:clear-all-code-block-outputs" = [
    {
      "modifiers" = [
        "Mod"
        "Shift"
      ];
      "key" = "J";
    }
  ];
  "jupymd:force-sync" = [
    {
      "modifiers" = [
        "Alt"
        "Mod"
      ];
      "key" = "J";
    }
  ];
  # "app:toggle-left-sidebar" = [
  #   {
  #     "modifiers" = [
  #       "Mod"
  #     ];
  #     "key" = "E";
  #   }
  # ];
  # use this one because it focuses
  "notebook-navigator:toggle-left-sidebar" = [
    {
      "modifiers" = [
        "Mod"
      ];
      "key" = "E";
    }
  ];
  "notebook-navigator:toggle-dual-pane" = [
    {
      "modifiers" = [
        "Mod"
        "Shift"
      ];
      "key" = "[";
    }
  ];
  "notebook-navigator:toggle-dual-pane-orientation" = [
    {
      "modifiers" = [
        "Mod"
        "Shift"
      ];
      "key" = "]";
    }
  ];
  "notebook-navigator:toggle-compact-mode" = [
    {
      "modifiers" = [
        "Mod"
      ];
      "key" = "'";
    }
  ];
  "notebook-navigator:collapse-expand" = [
    {
      "modifiers" = [
        "Alt"
      ];
      "key" = "W";
    }
  ];
  "notebook-navigator:toggle-descendants" = [
    {
      "modifiers" = [
        "Alt"
        "Mod"
      ];
      "key" = "W";
    }
  ];
  "notebook-navigator:reveal-file" = [
    {
      "modifiers" = [
        "Alt"
      ];
      "key" = "R";
    }
  ];
  # Request notebook-navigator search using omnisearch command
  "omnisearch:show-modal" = [
    {
      "modifiers" = [
        "Alt"
      ];
      "key" = "Z";
    }
  ];
  "notebook-navigator:search-vault" = [
    {
      "modifiers" = [
        "Alt"
      ];
      "key" = "S";
    }
  ];
  "notebook-navigator:search" = [
    {
      "modifiers" = [
        "Alt"
        "Shift"
      ];
      "key" = "S";
    }
  ];
}
// builtins.listToAttrs (
  map (n: {
    name = "notebook-navigator:open-shortcut-${toString n}";
    value = [
      {
        modifiers = [
          "Mod"
          "Shift"
        ];
        key = toString n;
      }
    ];
  }) (builtins.genList (x: x + 1) 9)
)

# not needed for now
# "cycle-in-sidebar:cycle-right-sidebar"= [
#   {
#     "modifiers"= [
#       "Mod"
#     ];
#     "key"= "]"
#   }
# ];
# "cycle-in-sidebar:cycle-right-sidebar-reverse"= [
#   {
#     "modifiers"= [
#       "Mod"
#     ];
#     "key"= "["
#   }
# ]
# "cycle-in-sidebar:cycle-left-sidebar"= [
#   {
#     "modifiers"= [
#       "Mod"
#       "Shift"
#     ];
#     "key"= "."
#   }
# ];
# "cycle-in-sidebar:cycle-left-sidebar-reverse"= [
#   {
#     "modifiers"= [
#       "Mod"
#       "Shift"
#     ];
#     "key"= ";"
#   }
# ]
