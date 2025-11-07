# lib/nixgl-wrapper.nix
{ lib }:
{
  # Creates a nixGL wrapper script in ~/.local/bin
  mkNixGLWrapper =
    {
      name,
      command,
      nixGLVariant ? "nixGL",
      extraArgs ? "",
      envVars ? "",
    }:
    {
      home.file.".local/bin/${name}" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash
          exec ${
            lib.optionalString (envVars != "") "env ${envVars} "
          }${nixGLVariant} ${command} ${extraArgs} "$@"
        '';
      };
    };
}
