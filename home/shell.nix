{
  config,
  pkgs,
  ...
}: {
  # Declarative PATH management (replaces manual export in initContent)
  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.local/bin"
    "$HOME/go/bin"
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history.size = 10000;

    initContent = ''
      setopt AUTO_CD
      export CARGO_TARGET_DIR=~/cargo-target
    '';
  };

  home.shellAliases = {
    urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
    urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";

    n = "nvim";
    nr = "npm run";
    ws = "cd ~/workspace";
    c = "clear";
    ls = "eza --icons=always";
    ll = "eza -l --icons=always";
    la = "eza -la --icons=always";
    ".." = "cd ..";
    "-" = "cd -";
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # Replaces manual `eval "$(zoxide init zsh)"` in initContent
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
