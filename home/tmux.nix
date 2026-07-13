{pkgs, ...}: {
  programs.tmux = {
    enable = true;

    # ====== BASIC ======
    mouse = true;
    keyMode = "vi";
    prefix = "C-a";
    terminal = "tmux-256color";

    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 10000;

    # ====== PLUGINS (NIX NATIVE) ======
    plugins = with pkgs.tmuxPlugins; [
      sensible
      cpu
      battery
      vim-tmux-navigator

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

      # Resurrect (phải load trước Continuum)
      {
        plugin = pkgs.tmuxPlugins.resurrect;
        extraConfig = ''
          set -g @resurrect-capture-pane-contents 'on'
        '';
      }

      # Continuum (bắt buộc phải load CUỐI CÙNG, sau khi status-right đã được Catppuccin set)
      {
        plugin = pkgs.tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '10'
        '';
      }
    ];

    extraConfig = ''
      # ====== FIX TRUE COLOR (Đặc biệt cho Neovim) ======
      set-option -sa terminal-overrides ",xterm*:Tc"
      set-option -g focus-events on
      set-option -g renumber-windows on # Tự động đánh lại số khi có 1 window bị đóng

      # ====== SPLIT WINDOWS ======
      unbind %
      bind | split-window -h -c "#{pane_current_path}"
      unbind '"'
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      # ====== RESIZE ======
      bind -r j resize-pane -D 5
      bind -r k resize-pane -U 5
      bind -r l resize-pane -R 5
      bind -r h resize-pane -L 5
      bind -r m resize-pane -Z

      # ====== COPY MODE ======
      bind-key -T copy-mode-vi v send -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
      unbind -T copy-mode-vi MouseDragEnd1Pane
      bind-key -T copy-mode-vi Escape send-keys -X cancel
    '';
  };
}
