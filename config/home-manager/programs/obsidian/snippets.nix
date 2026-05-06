# # programs/obsidian/snippets.nix
# {
#   pkgs,
#   ...
# }:
# # TODO: snippet the callout colors
# # also Ctrl + Shift + i | to use console and manually modify
# [
#   {
#     name = "right-ribbon";
#     enable = true;
#     text = ''
#       .workspace-ribbon {
#         order: 3;
#         position: relative;
#       }
#       .sidebar-toggle-button {
#         display: none;
#       }
#       .workspace-ribbon.mod-left:before {
#         display: none;
#       }
#     '';
#   }
#   {
#     name = "hide-vault-profiles";
#     enable = true;
#     text = ''
#       .workspace-sidedock-vault-profile {
#         display: none !important;
#       }
#     '';
#   }
#   {
#     name = "hide-copycode-button";
#     enable = true;
#     text = ''
#       button:has(svg.lucide-copy) { 
#         display: none !important;
#       }
#     '';
#   }
#   {
#     name = "theme-prismjs-jupytermd";
#     enable = true;
#     text = ''
#       .split-run-button.split-run-button-toggle,
#       .code-lang-label {
#         display: none !important;
#       }
#       .split-run-button { white-space: nowrap; }
#       .split-run-button.split-run-button-main { 
#         background: var(--background-primary);
#         color: var(--text-normal);
#       }
#       .code-buttons { display: flex; align-items: center; gap: 8px; }
#       .run-action-group { display: flex; align-items: center; gap: 6px; flex-shrink: 0; }
#       .code-buttons .icon-button { 
#         flex-shrink: 0;
#         background: var(--background-primary);
#         color: var(--text-normal);
#       }
#       .token {
#         &.punctuation,
#         &.operator {
#           color: var(--text-normal);
#         }
#         &.number,
#         &.boolean {
#           color: var(--color-green);
#         }
#         &.keyword {
#           color: var(--text-accent-hover);
#         }
#         &.string {
#           color: var(--color-blue);
#         }
#       }
#     '';
#   }
  {
    name = "theme-shiki-code";
    enable = true;
    text = ''
      .has-collapse-button.ccb-code-block,
      code.ccb-hide-vertical-scrollbar {
        background: var(--background-primary) !important;
      }
      .code {
        --shiki-code-punctuation: var(--text-normal);
        --shiki-code-important: var(--text-normal);
        --shiki-code-operator: var(--text-normal);
        --shiki-code-function: var(--color-red);
        --shiki-code-keyword: var(--color-cyan);
        --shiki-code-string: var(--color-blue);
        --shiki-code-value: var(--color-green);
      }
    '';
  }
#   # BUG: no background when custom colors
#   {
#     name = "lovely-bases-card";
#     enable = true;
#     text = ''
#       .theme-dark .lovely-bases,
#       .theme-light .lovely-bases {
#         --card: color-mix(in srgb, var(--background-primary) 95%, white);
#       }
#     '';
#   }
# ]
