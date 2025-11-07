#!/usr/bin/env python3
import i3ipc

i3 = i3ipc.Connection()


def on_window_focus(i3, event):
    for w in i3.get_tree().leaves():
        if w.focused:
            w.command("border pixel 4")  # focused window
        else:
            w.command("border pixel 0")  # unfocused windows


i3.on("window::focus", on_window_focus)
i3.main()
