# lib/nixgl-wrapper.nix
{ lib }:
{
  # Creates a nixGL wrapper script in ~/.local/bin
  mkNixGLWrapper =
    {
      name,
      command,
      envVars ? "",
      extraArgs ? "",
      nixGLVariant ? "nixGL",
    }:
    let
      arg0 = builtins.baseNameOf command;
    in
    {
      home.file.".local/bin/${name}" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash
          exec -a "${arg0}" ${
            lib.optionalString (envVars != "") "env ${envVars} "
          }${nixGLVariant} ${command} ${extraArgs} "$@"
        '';
      };
    };
}
