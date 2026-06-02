{
  pkgs,
  config,
  inputs,
  ...
}: let
  unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  dotfiles = "${config.home.homeDirectory}/nix-config/dotfiles";
in {
  # 🧠 Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    package = unstable.neovim-unwrapped;
  };

  # Multiple nvim configs using NVIM_APPNAME (Neovim >= 0.9)
  # Each config has its own isolated data/state/cache dirs:
  #   ~/.local/share/<NVIM_APPNAME>/
  #   ~/.local/state/<NVIM_APPNAME>/
  #   ~/.cache/<NVIM_APPNAME>/
  xdg.configFile = {
    # Default config (custom) — used when running `nvim`
    "nvim".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfiles}/nvim/nvim";

    # Alternative configs — accessed via aliases below
    "nvim-lazyvim".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfiles}/nvim/lazynvim";
    "nvim-nvchad".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfiles}/nvim/nvchad";
  };

  # Aliases to launch alternative nvim configs
  # Usage: `lazyvim` or `nvchad` to open with that distro's config
  home.shellAliases = {
    lazyvim = "NVIM_APPNAME=nvim-lazyvim nvim";
    nvchad = "NVIM_APPNAME=nvim-nvchad nvim";
  };
}
