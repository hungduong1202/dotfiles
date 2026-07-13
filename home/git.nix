{
  lib,
  username,
  useremail,
  ...
}: {
  # `programs.git` will generate the config file: ~/.config/git/config
  # to make git use this config file, `~/.gitconfig` should not exist!
  #
  #    https://git-scm.com/docs/git-config#Documentation/git-config.txt---global
  home.activation.removeExistingGitconfig = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    rm -f ~/.gitconfig
  '';

  programs.git = {
    enable = true;
    lfs.enable = true;

    # Use `includes` with `condition` for per-directory git identity:
    # includes = [{
    #   path = "~/work/.gitconfig";
    #   condition = "gitdir:~/work/";
    # }];

    settings = {
      user.email = useremail;
      user.name = username;

      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;

      alias = {
        br = "branch";
        co = "checkout";
        st = "status";
        cm = "commit -m";
        ca = "commit -am";
        dc = "diff --cached";
        amend = "commit --amend -m";
      };

      core = {
        editor = "nvim";
      };
    };

    ignores = [
      ".DS_Store"
      ".direnv"
      "node_modules"
      "result"
      "mise.toml"
    ];
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      features = "side-by-side line-numbers decorations";
      syntax-theme = "Dracula";
    };
  };
}
