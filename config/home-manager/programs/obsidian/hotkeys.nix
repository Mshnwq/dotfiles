# programs/obsidian/hotkeys.nix
{
  ...
}:
{
  "app:open-settings" = [
    {
      "modifiers" = [
        "Mod"
      ];
      "key" = "`";
    }
  ];
  "app:toggle-left-sidebar" = [
    {
      "modifiers" = [
        "Mod"
      ];
      "key" = "E";
    }
  ];
  "app:toggle-ribbon" = [
    {
      "modifiers" = [
        "Mod"
      ];
      "key" = "R";
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
  "app:toggle-right-sidebar" = [
    {
      "modifiers" = [
        "Mod"
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
  "editor:delete-paragraph" = [ ];
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
        "Shift"
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
  "app:go-back" = [
    {
      "modifiers" = [
        "Alt"
      ];
      "key" = "ArrowLeft";
    }
  ];
  "app:go-forward" = [
    {
      "modifiers" = [
        "Alt"
      ];
      "key" = "ArrowRight";
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
}
