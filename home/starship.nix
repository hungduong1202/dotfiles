{ ... }: {
  programs.starship = {
    enable = true;

    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;

    settings = {
      character = {
        success_symbol = "[›](bold green)";
        error_symbol = "[›](bold red)";
      };
      aws = {
        symbol = "🅰 ";
      };
      gcloud = {
        # do not show the account/project's info
        # to avoid the leak of sensitive information when sharing the terminal
        format = "on [$symbol$active(\($region\))]($style) ";
        symbol = "🅶 ️";
      };
    };

  #   settings = {
  #   add_newline = false;
  #
  #   format = "$username$hostname$directory$git_branch$git_status$cmd_duration\n$character";
  #
  #   character = {
  #     success_symbol = "[❯](bold green)";
  #     error_symbol = "[❯](bold red)";
  #   };
  #
  #   directory = {
  #     truncation_length = 3;
  #     style = "bold cyan";
  #   };
  #
  #   git_branch = {
  #     symbol = "";
  #     style = "bold purple";
  #   };
  #
  #   git_status = {
  #     style = "red";
  #     format = "[$all_status$ahead_behind]($style)";
  #   };
  #
  #   cmd_duration = {
  #     min_time = 500;
  #     format = "[⏱ $duration](dimmed white)";
  #   };
  #
  #   # disable noisy stuff
  #   nodejs.disabled = true;
  #   package.disabled = true;
  #   python.disabled = true;
  #   docker_context.disabled = true;
  #   golang.disabled = true;
  #   rust.disabled = true;
  # };
  };
}
