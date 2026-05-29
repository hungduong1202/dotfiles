{
  pkgs,
  config,
  inputs,
  ...
}: let
  unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
  dotfiles = "${config.home.homeDirectory}/.config/nix/dotfiles";

  # 🔥 DOTNET COMBINED
  userlocal = ''
    for i in $out/sdk/*; do
      i=$(basename $i)
      length=$(printf "%s" "$i" | wc -c)
      substring=$(printf "%s" "$i" | cut -c 1-$(expr $length - 2))
      i="$substring""00"
      mkdir -p $out/metadata/workloads/''${i/-*}
      touch $out/metadata/workloads/''${i/-*}/userlocal
    done
  '';

  postInstallUserlocal = final: prev: {
    postInstall = (prev.postInstall or "") + userlocal;
  };

  postBuildUserlocal = final: prev: {
    postBuild = (prev.postBuild or "") + userlocal;
  };

  dotnet-combined = (with pkgs.dotnetCorePackages;
    combinePackages [
      (sdk_10_0.overrideAttrs postInstallUserlocal)
      (sdk_9_0.overrideAttrs postInstallUserlocal)
      (sdk_8_0.overrideAttrs postInstallUserlocal)
    ])
    .overrideAttrs
  postBuildUserlocal;
in {
  home.packages = with pkgs; [
    # 📦 Archive
    curl
    wget
    zip
    unzip
    xz
    p7zip
    zstd
    gnutar
    gzip
    icu
    zlib

    # 🔍 Search
    ripgrep
    jq
    yq-go
    fd

    # 🔎 Fuzzy
    fzf
    zoxide

    # 🌐 Network
    aria2
    socat
    nmap

    # 🧰 Core
    gnused
    gawk
    file
    which

    # 🔐 Security
    gnupg
    openssl

    # 🌍 Web
    caddy

    # 🎨 CLI
    glow
    cowsay
    bat

    # 🧠 Dev
    git
    tmux
    lazygit
    unstable.tree-sitter
    statix

    # 🧱 Build
    gcc
    cmake
    pkg-config

    # 🧪 Languages
    python3
    nodejs_20
    flutter

    # LSP
    alejandra
    nil

    # 🧰 Extra
    sqlite
    readline
    rsync
    fswatch
    tree

    # 🔥 .NET + C#
    dotnet-combined

    csharp-ls

    netcoredbg

    # 📱 Android / MAUI
    # android-sdk
    # gradle
    # jdk17

    llvm_18
    ascii-image-converter

    nodePackages."@nestjs/cli"
  ];

  # 🌍 ENV
  home.sessionVariables = {
    DOTNET_ROOT = "${dotnet-combined}";

    JAVA_HOME = pkgs.jdk17.home;

    DOTNET_CLI_TELEMETRY_OPTOUT = "1";
    DOTNET_SKIP_FIRST_TIME_EXPERIENCE = "1";
  };

  # 🧠 Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    package = unstable.neovim-unwrapped;
  };

  home.file.".tmux.conf".source = ../dotfiles/tmux/.tmux.conf;

  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/nvim/nvim";
  #   config.lib.file.mkOutOfStoreSymlink "${dotfiles}/nvim/nvchad";
  # config.lib.file.mkOutOfStoreSymlink "${dotfiles}/nvim/lazynvim";
}
