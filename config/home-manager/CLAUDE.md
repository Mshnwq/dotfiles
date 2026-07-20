# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A Nix flake providing a single [home-manager](https://home-manager.dev) configuration (`homeConfigurations."mshnwq"`, `x86_64-linux`) for user `mshnwq`. `targets.genericLinux.enable = true` in `user.nix` means it's designed to also run on non-NixOS distros (standalone home-manager), not just NixOS.

This directory is `config/home-manager` inside a larger dotfiles repo whose parent is managed with GNU Stow (see `.stow-local-ignore`), but this directory is also a fully self-contained flake on its own.

## Commands

- `home-manager switch --flake .#mshnwq` — build and activate the configuration.
- `nix flake check` — evaluate/check the flake.
- `nix flake update` — update all flake inputs; `nix flake lock --update-input <name>` to bump one input.
- `ENABLE_SOPS=true home-manager switch --flake .#mshnwq` — activate with real secrets decryption enabled (see Secrets below); without this env var, sops uses dummy/placeholder secrets so the config still evaluates and builds for anyone without the real age key.

There is no repo-level formatter/lint entrypoint (`nix fmt`, treefmt, pre-commit) — `nixfmt`/`nixd` are only wired up as LSP tooling inside the managed Neovim config (`programs/neovim/default.nix`), not as a repo command.

## Architecture

### Entry point and lib extension

`flake.nix` builds `pkgs` with two overlay layers (in order): `pkgs/overlays.nix` (registers this repo's custom packages from `pkgs/*.nix`, e.g. `mermaid-ascii`, `niflveil`, `shyfox`, `guitar`, `guitarpro`) then `overlays/default.nix` (pulls in overlays from flake inputs like `nixgl`/`nur`, plus local package patches such as `overlays/lmms.nix`, `overlays/yt-dlp.nix`).

`self.lib` extends `nixpkgs.lib` via `lib/default.nix`, which brings in `bird-nix-lib`'s overlay (this is where `lib.importDir'` — the auto-discovery helper described below — comes from) plus a custom `nixgl` lib helper (`lib/nixgl-wrapper.nix`).

All flake inputs are threaded through as `inputs'` = `inputs // { useSops = ... }` (see Secrets), and this augmented set — not the raw flake `inputs` — is what gets passed into `lib/default.nix`, `overlays/default.nix`, `pkgs/overlays.nix`, and ultimately `user.nix`.

### Auto-discovery via `lib.importDir'`

This repo avoids manually wiring up an import list per file. `lib.importDir' <dir> <selfFilename>` (from `bird-nix-lib`) scans a directory, imports every `.nix` file/subdirectory except the one named `selfFilename` (to avoid self-import), and returns an attrset keyed by filename/dirname.

This is used at two levels:

1. **`user.nix`** calls `lib.importDir' ./. "user.nix"` to pick up top-level dirs, then does `user.programs args` to get at `programs/default.nix`'s exports.
2. **`programs/default.nix`** calls `lib.importDir' ./. "default.nix"` over the `programs/` dir, then `lib.mapAttrs` applies `args` (`{self, config, lib, pkgs, inputs, ...}`) to any exported value that is a function. The result is merged with a few home-manager modules defined inline in `programs/default.nix` itself (`default`, `vim`, `devenv`, `auto`, `git`, `rust`, `daw`).

**Practical consequence:** to add a new managed program, drop a new `programs/<name>.nix` (or `programs/<name>/default.nix`) file — it is picked up automatically as `programs.<name>` with no registration elsewhere. It must still be referenced by name in `user.nix`'s `imports` list to actually be activated.

### Program module shapes

Files under `programs/` follow one of three shapes:

- **Plain attrset** — a ready-made home-manager module, e.g. `vim`, `git`, `rust`, `daw`, `auto`, `devenv` (all defined directly inside `programs/default.nix`).
- **Function returning a single module** — `{config, lib, pkgs, inputs, ...}: {...}`, used directly as one `imports` entry, e.g. `programs/obsidian/default.nix`, `programs/neovim/default.nix`, `programs/hypr.nix`, `programs/infra.nix`, `programs/mime.nix`.
- **Function/attrset returning *nested variants*** — keyed by sub-name, referenced in `user.nix` as `programs.<name>.<variant>`. Examples: `discord.stable` / `discord.canary` (`programs/discord.nix`, via a shared `mkDiscordVariant` builder) and `keyboard.vial` / `keyboard.kmonad` (`programs/keyboard.nix`).

Larger programs live in their own subdirectory (`neovim/`, `obsidian/`, `firefox/`, `tmux/`, `yazi/`) split into `default.nix` (the module home-manager sees) plus plain helper files it `import`s directly (e.g. `obsidian/plugins.nix`, `obsidian/hotkeys.nix`, `obsidian/snippets.nix`, `neovim/builds.nix`, `yazi/keymap.nix`, `yazi/settings.nix`, `tmux/config.nix`, `tmux/plugins.nix`). Only the subdirectory's `default.nix` is auto-discovered as a program; the sibling files are implementation detail, not separately registered.

### `modules/which-key.nix`

A standalone custom home-manager module (not under `programs/`, so not auto-discovered — it's imported explicitly in `user.nix`). It defines the `programs.which-key` option (a list of `{key, desc, cmd, submenu}` entries) and renders `~/.config/wlr-which-key/config.yaml`, pulling colors from the current pywal palette. Individual program modules (e.g. `programs/discord.nix`, `programs/obsidian/default.nix`) contribute their own launcher entries by setting `programs.which-key.entries` themselves; these get merged together (`lib.mkMerge`) rather than declared in one central place.

### Pywal theming is a cross-cutting dependency

Many modules read generated files from `$XDG_CACHE_HOME/wal/...` (color palettes, generated CSS/theme files) at activation time — e.g. `modules/which-key.nix`, `programs/obsidian/default.nix` (custom Obsidian theme/style-settings symlinks), `programs/infra.nix` (`k9s` skin). These are wired with `home.activation` hooks or `force = true` file generation, so a pywal re-run typically requires a `home-manager switch` (or the relevant activation script) to propagate into managed configs.

### Secrets (sops-nix)

`sops.age.keyFile` and `sops.defaultSopsFile` in `user.nix` switch between two pairs based on `inputs.useSops` (set in `flake.nix` from `builtins.getEnv "ENABLE_SOPS" == "true"`):

- unset/false (default): `secrets/dummy.yaml`, encrypted with the `dummy` age key in `.sops.yaml` — safe placeholder values, lets the flake evaluate/build without the real key.
- `ENABLE_SOPS=true`: `secrets/primary.yaml`, encrypted with the `primary` age key — the real secrets, requires the actual age key file on disk.

Individual modules declare their own `sops.secrets.<name>` (e.g. `programs/hypr.nix` for keyboard layout config, `programs/keyboard.nix` for the kmonad device id, `programs/obsidian/default.nix` for the notebook-navigator config) and read them back via `config.sops.secrets.<name>.path`, generally guarding with `builtins.pathExists` for the dummy-secrets case where a file may not actually exist yet.
