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
      vim-tmux-navigator

      {
        plugin = pkgs.tmuxPlugins.catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor "mocha"
          set -g @catppuccin_window_status_style "rounded"

          # Hien thi ten window la ten thu muc
          set -g @catppuccin_window_default_text " #{b:pane_current_path}"
          set -g @catppuccin_window_current_text " #{b:pane_current_path}"
          set -g @catppuccin_window_text " #{b:pane_current_path}"

          set -g status-right-length 100
          set -g status-left-length 100

          # Canh giữa danh sách các Window
          set -g status-justify absolute-centre

          # Dua Session va Application sang ben trai
          set -g status-left "#{E:@catppuccin_status_session}"
          set -ag status-left "#{E:@catppuccin_status_application}"

          # Xoa toan bo thong tin phia ben phai (info may, time...)
          set -g status-right ""
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
      # ====== UI / UX ======
      set-option -g status-position top

      # Khung (pane) bắt đầu từ 1
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1

      # ====== HIGHLIGHT ACTIVE PANE (PRESERVE TRANSPARENCY) ======
      # Bật thanh tiêu đề (frame) cho từng pane để dễ nhìn hơn
      # set -g pane-border-status top
      # set -g pane-border-format " [ ###P #T ] "

      # Đổi màu đường viền của pane không active (màu xám tối)
      set -g pane-border-style "fg=#45475a,bg=default"
      # Đổi màu đường viền pane đang active (Màu Mauve/Pink của Catppuccin)
      set -g pane-active-border-style "fg=#cba6f7,bg=default"

      # Làm mờ chữ (dim text) của các pane không active, nhưng GIỮ NGUYÊN nền trong suốt (bg=default)
      set -g window-active-style "fg=terminal,bg=default"
      set -g window-style "fg=#7f849c,bg=default" # Chữ màu xám (Overlay 0) cho pane không active

      # Mặc định sort session theo tên (bảng chữ cái)
      bind s choose-tree -sZ -O name

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
