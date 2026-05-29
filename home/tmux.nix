{pkgs, ...}: {
  programs.tmux = {
    enable = true;

    # ====== BASIC ======
    mouse = true;
    keyMode = "vi";
    prefix = "C-a";
    terminal = "tmux-256color";

    # ====== PLUGINS (NIX NATIVE) ======
    plugins = with pkgs.tmuxPlugins; [
      sensible
      cpu
      battery
      vim-tmux-navigator
      continuum
      resurrect

      # Catppuccin (custom vì nixpkgs đôi khi chưa có hoặc outdated)
      {
        plugin = pkgs.tmuxPlugins.catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor "mocha"
          set -g @catppuccin_window_status_style "rounded"

          set -g status-right-length 100
          set -g status-left-length 101
          set -g status-left ""
          set -g status-right "#{E:@catppuccin_status_application}"
          set -agF status-right "#{E:@catppuccin_status_cpu}"
          set -ag status-right "#{E:@catppuccin_status_session}"
          set -ag status-right "#{E:@catppuccin_status_uptime}"
          set -agF status-right "#{E:@catppuccin_status_battery}"
        '';
      }
    ];

    extraConfig = ''
      # Split
      unbind %
      bind | split-window -h
      unbind '"'
      bind - split-window -v

      # Resize
      bind -r j resize-pane -D 5
      bind -r k resize-pane -U 5
      bind -r l resize-pane -R 5
      bind -r h resize-pane -L 5
      bind -r m resize-pane -Z

      # Navigate panes (vim style)
      bind-key C-h if-shell "[[ $(tmux display -p '#{pane_in_mode}') -eq 1 ]]" "send-keys C-h" "select-pane -L"
      bind-key C-j if-shell "[[ $(tmux display -p '#{pane_in_mode}') -eq 1 ]]" "send-keys C-j" "select-pane -D"
      bind-key C-k if-shell "[[ $(tmux display -p '#{pane_in_mode}') -eq 1 ]]" "send-keys C-k" "select-pane -U"
      bind-key C-l if-shell "[[ $(tmux display -p '#{pane_in_mode}') -eq 1 ]]" "send-keys C-l" "select-pane -R"

      # Copy mode
      bind-key -T copy-mode-vi v send -X begin-selection
      bind-key -T copy-mode-vi y send -X copy-selection
      unbind -T copy-mode-vi MouseDragEnd1Pane

      # ====== RESURRECT / CONTINUUM ======
      set -g @resurrect-capture-pane-contents 'on'
      set -g @continuum-restore 'on'
      set -g @continuum-save-interval '10'
    '';
  };
}
