{config,pkgs, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history.size = 10000;

    initContent = ''
      setopt AUTO_CD
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
      export CARGO_TARGET_DIR=~/cargo-target
      eval "$(zoxide init zsh)"
    '';
  };

  home.shellAliases = {
    urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
    urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";

    n = "nvim";
    nr =  "npm run";
    ws = "cd ~/workspace";
    c = "clear";
    ll = "ls -l";
    la = "ls -la";
    ".." = "cd ..";
    "-" = "cd -";
  };


  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
