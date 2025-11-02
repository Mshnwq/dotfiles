#!/usr/bin/env bash
set -euo pipefail

# --- create flake.nix ---
cat > flake.nix <<'EOF'
{
  description = "Python 3.10 project with pip-managed venv";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      python = pkgs.python310; # Nixpkgs provides Python 3.10.x
    in {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          python
          python.pkgs.venvShellHook
        ];

        venvDir = ".venv";

        postShellHook = ''
          if [ ! -d ".venv" ]; then
            echo "Creating virtual environment in .venv"
            python -m venv .venv
          fi
          echo "Activating .venv"
          source .venv/bin/activate
        '';
      };
    };
}
EOF

# --- initialize flake if needed ---
if [ ! -f flake.lock ]; then
  echo "Running nix flake update to create lock file..."
  nix flake update
fi

echo
echo "✅ Setup complete!"
echo "Now run: nix develop"
echo "This will drop you into a shell with Python 3.10.x and .venv auto-activated."

https://github.com/dtgoitia/nix-python
