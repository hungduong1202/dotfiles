{
  pkgs,
  inputs,
  ...
}: let
  unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  home.packages = with pkgs; [
    # 📦 Archive (curl, wget, aria2 installed via Homebrew for better macOS compat)
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

    # 🌐 Network
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
    eza
    btop
    tealdeer

    # 🧠 Dev
    git
    lazygit
    unstable.tree-sitter
    statix

    # 🧱 Build
    gcc
    cmake
    pkg-config

    # 🧪 Languages
    # python3 # Managed by mise
    # nodejs_22 # Managed by mise
    flutter
    jdk17

    # LSP
    alejandra
    nil

    # 🧰 Extra
    sqlite
    readline
    rsync
    fswatch
    tree
    ffmpeg

    llvm_18
    ascii-image-converter

    nodePackages."@nestjs/cli"

    # 🤖 AI
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.antigravity-cli
  ];

  home.sessionVariables = {
    JAVA_HOME = pkgs.jdk17.home;
  };
}
