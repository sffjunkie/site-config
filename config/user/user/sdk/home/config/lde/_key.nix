{
  formatter,
  ...
}:
formatter.generate "desktop-key" {
  key = {
    modifier = {
      alt = "mod1";
      ctrl = "control";
      hyper = "mod3";
      shift = "shift";
      cmd = "mod4";
      super = "mod4";
    };
    modifier_group = {
      # Launch an application
      app_launch = [
        "cmd"
      ];

      fnbar_app_control = [
        "cmd"
      ];

      group_control = [ "cmd" ];

      group_switch_direction = [
        "cmd"
        "alt"
      ];

      group_switch_numbered = [ "cmd" ];

      menu_launch = [
        "cmd"
        "alt"
      ];

      screen_switch = [
        "cmd"
        "alt"
        "ctrl"
      ];

      vt_switch = [
        "ctrl"
        "alt"
      ];

      window_control = [
        "cmd"
        "ctrl"
      ];

      window_move = [
        "cmd"
        "shift"
      ];

      window_move_to_group = [
        "cmd"
        "shift"
      ];

      window_resize = [
        "cmd"
        "ctrl"
      ];

      window_switch = [ "cmd" ];

      wm_control = [
        "cmd"
        "alt"
        "ctrl"
      ];
    };
    defs = [
      {
        key = "F1";
        modifier_group = "menu_launch";
        command = "lwm:spawn:menu.user";
        desc = "Show the user menu";
      }
      {
        key = "F12";
        modifier_group = "menu_launch";
        command = "lwm:spawn:menu.system";
        desc = "Show the system menu";
      }
      {
        key = "Return";
        modifier_group = "app_launch";
        command = "lwm:spawn:app.launcher";
        desc = "Show the app launcher";
      }
      {
        key = "w";
        modifier_group = "app_launch";
        command = "lwm:spawn:app.browser";
        desc = "Launch the browser";
      }
      {
        key = "b";
        modifier_group = "app_launch";
        command = "lwm:spawn:app.brain";
        desc = "Launch the second brain";
      }
      {
        key = "c";
        modifier_group = "app_launch";
        command = "lwm:spawn:app.code_editor";
        desc = "Launch the code editor";
      }
      {
        key = "t";
        modifier_group = "app_launch";
        command = "lwm:spawn:app.terminal";
        desc = "Launch the terminal";
      }
      {
        key = "Left";
        modifier_group = "window_switch";
        command = "qtile:group.prev_window";
        desc = "Previous window";
      }
      {
        key = "Right";
        modifier_group = "window_switch";
        command = "qtile:group.next_window";
        desc = "Next window";
      }
      {
        key = "Left";
        modifier_group = "window_resize";
        command = "qtile:layout.shrink_main";
        desc = "Decrease Main Window Size";
      }
      {
        key = "Right";
        modifier_group = "window_resize";
        command = "qtile:layout.grow_main";
        desc = "Increase Main Window Size";
      }
      {
        key = "Up";
        modifier_group = "window_resize";
        command = "qtile:layout.grow";
        desc = "Increase Sub Window Size";
      }
      {
        key = "Down";
        modifier_group = "window_resize";
        command = "qtile:layout.shrink";
        desc = "Decrease Sub Window Size";
      }
      {
        key = "Left";
        modifier_group = "window_move";
        command = "qtile:layout.shuffle_up";
        desc = "Move window up in stack";
      }
      {
        key = "Right";
        modifier_group = "window_move";
        command = "qtile:layout.shuffle_down";
        desc = "Move window down in stack";
      }
      {
        key = "grave";
        modifier_group = "group_control";
        command = "qtile:next_layout";
        desc = "Switch layout";
      }
      {
        key = "Left";
        modifier_group = "group_switch_direction";
        command = "qtile:screen.prev_group";
        desc = "Switch to previous group";
      }
      {
        key = "Right";
        modifier_group = "group_switch_direction";
        command = "qtile:screen.next_group";
        desc = "Switch to next group";
      }
      {
        key = "Left";
        modifier_group = "screen_switch";
        command = "qtile:prev_screen";
        desc = "Switch to previous screen";
      }
      {
        key = "Right";
        modifier_group = "screen_switch";
        command = "qtile:screen.next_screen";
        desc = "Switch to next group";
      }
      {
        key = "Insert";
        modifier_group = "app_launch";
        command = "lwm:spawn:controller.clipboard.cmd_copy";
        desc = "Copy an item from the clipboard history";
      }
      {
        key = "Delete";
        modifier_group = "app_launch";
        command = "lwm:spawn:controller.clipboard.cmd_delete";
        desc = "Copy an item from the clipboard history";
      }
      {
        key = "s";
        modifier_group = "app_launch";
        command = "lwm:spawn:app.screenshot";
        desc = "Take a screenshot";
      }
      {
        key = "Delete";
        modifier_group = "wm_control";
        command = "lwm:spawn:menu.wm";
        desc = "LWM Control";
      }
      {
        key = "F8";
        modifier_group = "fnbar_app_control";
        command = "lwm:spawn:controller.music.cmd_toggle";
        desc = "Toggle music play/pause";
      }
      {
        key = "F7";
        modifier_group = "fnbar_app_control";
        command = "lwm:spawn:controller.music.cmd_previous";
        desc = "Play previous music track";
      }
      {
        key = "F9";
        modifier_group = "fnbar_app_control";
        command = "lwm:spawn:controller.music.cmd_next";
        desc = "Play next music track";
      }
      {
        key = "F9";
        modifier_group = "app_launch";
        command = "lwm:spawn:notifier.music_track_change";
        desc = "Show latest music notification";
      }
      {
        key = "c";
        modifier_group = "window_control";
        command = "qtile:window.kill";
        desc = "Close window";
      }
      {
        key = "f";
        modifier_group = "window_control";
        command = "qtile:window.toggle_floating";
        desc = "Toggle tiled/floating window";
      }
      {
        key = "m";
        modifier_group = "window_control";
        command = "qtile:window.toggle_maximize";
        desc = "Toggle maximized window";
      }
      {
        key = "F1";
        modifier_group = "vt_switch";
        command = "qtile:core.change_vt:1";
        desc = "Switch to VT 1";
      }
      {
        key = "F2";
        modifier_group = "vt_switch";
        command = "qtile:core.change_vt:2";
        desc = "Switch to VT 2";
      }
      {
        key = "F3";
        modifier_group = "vt_switch";
        command = "qtile:core.change_vt:3";
        desc = "Switch to VT 3";
      }
      {
        key = "F4";
        modifier_group = "vt_switch";
        command = "qtile:core.change_vt:4";
        desc = "Switch to VT 4";
      }
      {
        key = "F5";
        modifier_group = "vt_switch";
        command = "qtile:core.change_vt:5";
        desc = "Switch to VT 5";
      }
      {
        key = "F6";
        modifier_group = "vt_switch";
        command = "qtile:core.change_vt:6";
        desc = "Switch to VT 6";
      }
    ];
  };
}
