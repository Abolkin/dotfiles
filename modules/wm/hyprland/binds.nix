# Hyprland keybindings configuration
{hostname ? "default"}: let
  # Import the special app script
  special_app = ../../../scripts/special_app.sh;
  special_workspace = appName: workspaceName: let
    checkCommand = "hyprctl clients | grep '${appName}'";
  in "${checkCommand} && hyprctl dispatch togglespecialworkspace ${workspaceName} || ${appName}";

  # Helper function to create bindings
  mkBind = mod: key: action: "${mod}, ${key}, ${action}";

  # Common bindings shared across all hosts
  commonBinds = {
    # Terminal
    "ALT, 36" = "exec, kitty"; # 36 = Return key

    # Browser
    "SUPER, L" = "exec, zen"; # Launch Zen browser

    # Dictation
    # ", F5" = "exec, ~/.local/bin/whisper-dictate"; # Voice dictation with whisper (F5 key)
    # ", mouse:274" = "exec, ~/.local/bin/whisper-dictate"; # Voice dictation with middle mouse button

    # Caelestia shell bindings
    "SUPER, D" = "exec, caelestia shell toggle dashboard";
    "SUPER, SPACE" = "exec, caelestia shell toggle launcher";
    "SUPER, S" = "exec, caelestia shell toggle session";

    # Special workspace toggles
    "ALT, Q" = "exec, ${special_app} kitty";
    "ALT, W" = "exec, ${special_app} zen";
    "ALT, E" = "exec, ${special_app} vesktop";
    "ALT, R" = "exec, ${special_workspace "slack" "slack"}";

    # Window management
    "ALT, 22" = "killactive,"; # 22 = Backspace
    "ALT, F" = "togglefloating,";
    "ALT, P" = "pseudo,"; # dwindle

    # Focus movement (vim-style)
    "ALT, h" = "movefocus, l";
    "ALT, l" = "movefocus, r";
    "ALT, j" = "movefocus, d";
    "ALT, k" = "movefocus, u";

    # Special workspaces
    "ALT, m" = "movetoworkspacesilent, special";
    "ALT, s" = "togglespecialworkspace,";

    # Window movement
    "ALT CTRL, h" = "movewindoworgroup, l";
    "ALT CTRL, l" = "movewindoworgroup, r";
    "ALT CTRL, j" = "movewindoworgroup, d";
    "ALT CTRL, k" = "movewindoworgroup, u";

    # Grouping
    "ALT, G" = "togglegroup,";
    "ALT, tab" = "changegroupactive,";

    # Mouse workspace navigation
    "ALT, mouse_down" = "workspace, e+1";
    "ALT, mouse_up" = "workspace, e-1";
  };

  # Workspace switching binds
  workspaceBinds = builtins.listToAttrs (
    builtins.concatLists (
      builtins.genList (
        i: let
          ws = toString (i + 1);
        in [
          {
            name = "ALT, ${toString (i + 1)}";
            value = "workspace, ${ws}";
          }
          {
            name = "SUPER, ${toString (i + 1)}";
            value = "movetoworkspace, ${ws}";
          }
        ]
      )
      9
    )
    ++ [
      {
        name = "ALT, 0";
        value = "workspace, 10";
      }
      {
        name = "SUPER, 0";
        value = "movetoworkspace, 10";
      }
    ]
  );

  # Mouse bindings (bindm)
  mouseBinds = {
    "ALT, mouse:272" = "movewindow";
    "ALT, mouse:273" = "resizewindow";
  };

  # Repeated bindings (binde)
  repeatingBinds = {
    "ALT CTRL, h" = "exec, hyprctl --batch 'dispatch movewindow l; dispatch moveactive -10 0'";
    "ALT CTRL, l" = "exec, hyprctl --batch 'dispatch movewindow r; dispatch moveactive 10 0'";
    "ALT CTRL, k" = "exec, hyprctl --batch 'dispatch movewindow u; dispatch moveactive 0 -10'";
    "ALT CTRL, j" = "exec, hyprctl --batch 'dispatch movewindow d; dispatch moveactive 0 10'";

    # Window resizing (repeats when held)
    "ALT SHIFT, H" = "resizeactive, -40 0";
    "ALT SHIFT, L" = "resizeactive, 40 0";
    "ALT SHIFT, J" = "resizeactive, 0 40";
    "ALT SHIFT, K" = "resizeactive, 0 -40";

    # Volume controls (keys 67, 68, 69)
    ", 67" = "exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; # Mute toggle
    ", 68" = "exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"; # Volume down (repeats when held)
    ", 69" = "exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"; # Volume up (repeats when held)
    ", 74" = "exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"; # Volume up (repeats when held)

    # Brightness controls (keys 75, 76)
    ", 75" = "exec, brightnessctl set 5%-"; # Brightness down (repeats when held)
    ", 76" = "exec, brightnessctl set +5%"; # Brightness up (repeats when held)
  };

  # Host-specific bindings
  hostSpecificBinds = {
    "nixos" = {
      # Laptop-specific bindings
      "SUPER, 47" = "exec, caelestia-quickshell shell toggle launcher"; # 47 = semicolon
    };

    "nixos-desktop" = {
      # Desktop-specific bindings could go here
      "SUPER, 47" = "exec, rofi -show drun"; # Different launcher for desktop
    };
  };

  # Host-specific repeating bindings (binde)
  hostSpecificRepeatingBinds = {
    "nixos" = {
      # Workspace increment/decrement for laptop
      "ALT, 59" = "workspace, -1"; # 60 = period key
      "ALT, 60" = "workspace, +1"; # 59 = comma key
      # "SUPER, j" = "workspace, +1"; # 59 = comma key
      # "SUPER, k" = "workspace, -1"; # 60 = period key
    };
  };
in {
  # Regular bindings
  bind = commonBinds // workspaceBinds // (hostSpecificBinds.${hostname} or {});

  # Mouse bindings
  bindm = mouseBinds;

  # Repeating bindings
  binde = repeatingBinds // (hostSpecificRepeatingBinds.${hostname} or {});
}
