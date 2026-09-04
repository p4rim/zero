-- Disable mouse focus for JetBrains popups that manage their own focus.
o.window("^(jetbrains-.*)$", { no_follow_mouse = true })
