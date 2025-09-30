{ config, ... }: {
    enable = true;
    config = let
        modifier = config.wayland.windowManager.sway.config.modifier;
        terminal = "alacritty";
        launcher = "j4-dmenu-desktop --dmenu='bemenu -il 16'";
        lock = "swaylock";

        keyLeft = "Left";
        keyRight = "Right";
        keyUp = "Up";
        keyDown = "Down";
    in {
        modifier = "Mod4";
        fonts = {
            names = ["Noto Sans"];
            size = 10.0;
        };
        input = {
            "*" = {
                middle_emulation = "disabled";
            };
        };
        output = {
            "*" = {
                #bg = "wallpaper.jpg fill";
            };
            # Laptop Display
            eDP-1 = {
                pos = "0 1080 res 1920x1200";
            };
            # HDMI
            HDMI-A-1 = {
                pos = "0 0 res 1920x1080";
            };
            # DisplayLink
            DVI-I-1 = {
                pos = "0 0 res 1920x1080";
            };
            DVI-I-2 = {
                pos = "1920 0 res 1920x1080";
            };
        };
        workspaceLayout = "tabbed";
        keybindings = {
            # Reload the configuration file
            "${modifier}+Shift+r" = "reload";
            # Exit sway
            "${modifier}+Shift+Escape" = "exit";

            # Launch Terminal
            "${modifier}+Return" = "exec ${terminal}";
            # Start Launcher
            "${modifier}+Space" = "exec ${launcher}";
            # Lock
            "${modifier}+L" = "exec ${lock}";

            # Screenshot
            "Print" = "exec grim -g \"$(slurp)\" - | wl-copy";
            "Shift+Print" = "exec grim - | wl-copy";

            # Close Focused Window
            "${modifier}+Shift+c" = "kill";

            # Change Focus
            "${modifier}+${keyLeft}" = "focus left";
            "${modifier}+${keyDown}" = "focus down";
            "${modifier}+${keyUp}" = "focus up";
            "${modifier}+${keyRight}" = "focus right";

            # Move Windows
            "${modifier}+Shift+${keyLeft}" = "move left";
            "${modifier}+Shift+${keyDown}" = "move down";
            "${modifier}+Shift+${keyUp}" = "move up";
            "${modifier}+Shift+${keyRight}" = "move right";

            # Switch to workspace
            "${modifier}+Tab" = "workspace back_and_forth";
            # bindgesture swipe:4:left workspace prev
            # bindgesture swipe:4:right workspace next
            "${modifier}+Ctrl+Shift+${keyLeft}" = "workspace prev";
            "${modifier}+Ctrl+Shift+${keyRight}" = "workspace next";
            "${modifier}+1" = "workspace number 1";
            "${modifier}+2" = "workspace number 2";
            "${modifier}+3" = "workspace number 3";
            "${modifier}+4" = "workspace number 4";
            "${modifier}+5" = "workspace number 5";
            "${modifier}+6" = "workspace number 6";
            "${modifier}+7" = "workspace number 7";
            "${modifier}+8" = "workspace number 8";
            "${modifier}+9" = "workspace number 9";
            "${modifier}+0" = "workspace number 10";
            # Move focused container to workspace
            "${modifier}+Shift+1" = "move container to workspace number 1";
            "${modifier}+Shift+2" = "move container to workspace number 2";
            "${modifier}+Shift+3" = "move container to workspace number 3";
            "${modifier}+Shift+4" = "move container to workspace number 4";
            "${modifier}+Shift+5" = "move container to workspace number 5";
            "${modifier}+Shift+6" = "move container to workspace number 6";
            "${modifier}+Shift+7" = "move container to workspace number 7";
            "${modifier}+Shift+8" = "move container to workspace number 8";
            "${modifier}+Shift+9" = "move container to workspace number 9";
            "${modifier}+Shift+0" = "move container to workspace number 10";

            # Toggle the current focus between tiling and floating mode
            "${modifier}+Shift+f" = "floating toggle";

            # Make the current focus fullscreen
            "${modifier}+f" = "fullscreen";

            # Switch the current layout
            "${modifier}+Shift+Tab" = "layout toggle tabbed split";

            # Sway has a "scratchpad", which is a bag of holding for windows.
            # You can send windows there and get them back later.

            # Move the currently focused window to the scratchpad
            "${modifier}+Shift+minus" = "move scratchpad";

            # Show the next scratchpad window or hide the focused scratchpad window.
            # If there are multiple scratchpad windows, this command cycles through them.
            "${modifier}+minus" = "scratchpad show";

            # Switch to resize mode.
            "${modifier}+r" = "mode \"resize\"";
        };
        modes = {
            resize = {
                "${keyLeft}" = "resize shrink width 10px";
                "${keyDown}" = "resize grow height 10px";
                "${keyUp}" = "resize shrink height 10px";
                "${keyRight}" = "resize grow width 10px";
                # Return to default mode
                "Return" = "mode \"default\"";
                "Escape" = "mode \"default\"";
            };
        };
        floating = {
            modifier = "${modifier} normal";
        };
        bars = [
            {
                position = "top";
                statusCommand = "while date +'%Y年%m月%d日(%a)  %H:%M:%S%p  🔋'\"$(cat /sys/class/power_supply/BAT0/capacity)\"'%%'; do sleep 1; done";
                fonts = {
                    names = ["Noto Sans"];
                    size = 10.0;
                };
                colors = {
                    statusline = "#ffffff";
                    background = "#323232";
                    inactiveWorkspace = {
                        border = "#32323200";
                        background = "#32323200";
                        text = "#5c5c5c";
                    };
                };
            }
        ];
    };
    extraConfigEarly = ''
        include /etc/sway/config.d/*
    '';
    extraConfig = ''
        default_border pixel 1

        # Notifications
        exec mako

        for_window [app_id="fzf-zos-doc"] floating enable, resize set width 1600 px, resize set height 800 px
    '';
}
