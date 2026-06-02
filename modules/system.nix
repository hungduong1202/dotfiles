{pkgs, ...}:
###################################################################################
#
#  macOS's System configuration
#
#  All the configuration options are documented here:
#    https://daiderd.com/nix-darwin/manual/index.html#sec-options
#
###################################################################################
{
  system = {
    stateVersion = 6;

    defaults = {
      menuExtraClock.Show24Hour = true;

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };

      dock = {
        autohide = true;
        show-recents = false;
        mru-spaces = false; # don't rearrange spaces based on recent use
        tilesize = 48;
      };

      finder = {
        _FXShowPosixPathInTitle = true; # show full path in title
        AppleShowAllExtensions = true;
        FXEnableExtensionChangeWarning = false;
        QuitMenuItem = true; # allow quitting Finder
        ShowPathbar = true;
        ShowStatusBar = true;
      };

      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        InitialKeyRepeat = 15; # faster key repeat
        KeyRepeat = 2;
        "com.apple.swipescrolldirection" = true; # natural scrolling
        ApplePressAndHoldEnabled = false; # allow key repeat for vim
        NSWindowResizeTime = 0.001; # speed up window resize animations
      };

      CustomUserPreferences = {
        "com.apple.desktopservices" = {
          DSDontWriteNetworkStores = true; # no .DS_Store on network volumes
          DSDontWriteUSBStores = true; # no .DS_Store on USB drives
        };
      };
    };
  };

  environment.systemPackages = [pkgs.pam-reattach];

  # Add ability to used TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;
  security.pam.services.sudo_local.reattach = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  # this is required if you want to use darwin's default shell - zsh
  programs.zsh.enable = true;
}
