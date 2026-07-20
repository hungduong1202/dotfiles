{
  pkgs,
  lib,
  ...
}: {
  programs.mise = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      experimental = true;
      verbose = false;
      auto_install = true;
    };
  };

  # activation script to set up mise configuration
  home.activation.setupMise = lib.hm.dag.entryAfter ["writeBoundary"] ''
    export PATH="${pkgs.python3}/bin:$PATH:${pkgs.curl}/bin:/usr/bin:/bin:/usr/sbin:/sbin"

    # use the virtual environment created by uv
    # ${pkgs.mise}/bin/mise settings set python.uv_venv_auto true

    # enable corepack (pnpm, yarn, etc.)
    ${pkgs.mise}/bin/mise set MISE_NODE_COREPACK=true

    # disable warning about */.node-version files
    ${pkgs.mise}/bin/mise settings add idiomatic_version_file_enable_tools "[]"

    # set global tool versions (auto_install will handle installation)
    ${pkgs.mise}/bin/mise use --global node@lts
    ${pkgs.mise}/bin/mise use --global python@3.12
    ${pkgs.mise}/bin/mise use --global uv@0.11.28
    ${pkgs.mise}/bin/mise use --global rust@stable
    ${pkgs.mise}/bin/mise use --global dotnet@latest
    ${pkgs.mise}/bin/mise use --global poetry@latest
  '';
}
