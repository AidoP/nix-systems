{ lib, pkgs, hostname, ... }: {
    networking.hostName = hostname;

    # Lock root
    users.users.root = {
        hashedPassword = "!";
    };

    security.sudo = {
        enable = true;
        extraRules = [{
            commands = [ "ALL" ];
            groups = [ "wheel" ];
        }];
    };

    # Boot configuration
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Networking
    networking.wireless.iwd = {
        enable = true;
        settings = {
            General = {
                EnableNetworkConfiguration = false;
            };
            Network = {
                EnableIPv6 = true;
                NameResolvingService = "systemd";
            };
            Settings = {
                AutoConnect = true;
            };
        };
    };
    networking.useNetworkd = true;
    systemd.network = {
        enable = true;
        networks = {
            "10-basic" = {
                name = "en* wlp* wlan*";
                dns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
                networkConfig = {
                    # DNSOverTLS = "yes";
                    DHCP = "yes";
                    MulticastDNS = "yes";
                    LLMNR = "no";
                };
                linkConfig = {
                    RequiredForOnline = "yes";
                };
            };
        };
    };

    # DNS Resolution
    services.resolved = {
        enable = true;
        dnssec = "true";
        #domains = [ "~." ];
        fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
        dnsovertls = lib.mkDefault "true";
        llmnr = "false";
    };

    # Localisation
    time.timeZone = "Australia/Perth";
    i18n.defaultLocale = "en_AU.UTF-8";

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_AU.UTF-8";
        LC_IDENTIFICATION = "en_AU.UTF-8";
        LC_MEASUREMENT = "en_AU.UTF-8";
        LC_MONETARY = "en_AU.UTF-8";
        LC_NAME = "en_AU.UTF-8";
        LC_NUMERIC = "en_AU.UTF-8";
        LC_PAPER = "en_AU.UTF-8";
        LC_TELEPHONE = "en_AU.UTF-8";
        LC_TIME = "ja_JP.UTF-8";
    };

    # Packages to always install
    environment.systemPackages = with pkgs; [];
    programs = {
        git = {
            enable = true;
            config = {
                init = {
                    defaultBranch = "main";
                };
            };
        };
        neovim = {
            enable = true;
            defaultEditor = true;
            withRuby = false;
            withPython3 = false;
            withNodeJs = false;
            vimAlias = true;
            viAlias = true;
        };
        zsh = {
            enable = true;
            interactiveShellInit = builtins.readFile ./config/zshrc;
# 	    ''# Prompt
# PS1='thinkpad %~ %#'
# RPS1='returned %?'
# 
# # Key Bindings
# # to add other keys to this hash, see: man 5 terminfo
# typeset -g -A key
# 
# key[Home]="${terminfo[khome]}"
# key[End]="${terminfo[kend]}"
# key[Insert]="${terminfo[kich1]}"
# key[Backspace]="${terminfo[kbs]}"
# key[Delete]="${terminfo[kdch1]}"
# key[Up]="${terminfo[kcuu1]}"
# key[Down]="${terminfo[kcud1]}"
# key[Left]="${terminfo[kcub1]}"
# key[Right]="${terminfo[kcuf1]}"
# key[PageUp]="${terminfo[kpp]}"
# key[PageDown]="${terminfo[knp]}"
# key[Shift-Tab]="${terminfo[kcbt]}"
# key[Control-Left]="${terminfo[kLFT5]}"
# key[Control-Right]="${terminfo[kRIT5]}"
# 
# # setup key accordingly
# [[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"       beginning-of-line
# [[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"        end-of-line
# [[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"     overwrite-mode
# [[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}"  backward-delete-char
# [[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"     delete-char
# [[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"         up-line-or-history
# [[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"       down-line-or-history
# [[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"       backward-char
# [[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"      forward-char
# [[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"     beginning-of-buffer-or-history
# [[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"   end-of-buffer-or-history
# [[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}"  reverse-menu-complete
# [[ -n "${key[Control-Left]}"  ]] && bindkey -- "${key[Control-Left]}"  backward-word
# [[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word
# 
# # Finally, make sure the terminal is in application mode, when zle is
# # active. Only then are the values from $terminfo valid.
# if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
#     autoload -Uz add-zle-hook-widget
#     function zle_application_mode_start { echoti smkx }
#     function zle_application_mode_stop { echoti rmkx }
#     add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
#     add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
# fi
# 
# # History Search
# autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
# zle -N up-line-or-beginning-search
# zle -N down-line-or-beginning-search
# 
# [[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
# [[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search
# 
# # Change the window title when running programs
# case $TERM in
#     xterm*|termite|alacritty|foot)
#         preexec () {
#             print -Pn "\e]0;${PWD/#$HOME/~} [$1]\a"
#         };
#     ;
# esac'';
        };
    };

    # Clean Old Nix Builds
    nix.gc = {
        automatic = true;
        dates = "monthly";
        options = "--delete-older-than 1m";
    };

    nix.settings.experimental-features = [
        "nix-command"
        "flakes"
    ];
}
