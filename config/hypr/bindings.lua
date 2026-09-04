-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   zero menu keybindings --print

-- To disable every Zero default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.zero"), then add
-- only the bindings you want below:
--   zero_default_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Zero root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Zero menu", "zero-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "zero-capture-screenshot")
-- o.bind("SUPER + PERIOD", nil, "zero-shell shell toggle zero.emojis")
