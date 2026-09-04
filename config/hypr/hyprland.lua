-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- Zero's bootstrap keeps path setup out of this user config.
dofile((os.getenv("ZERO_PATH") or "/usr/share/zero") .. "/default/hypr/bootstrap.lua")

-- Disable all Zero default bindings. Add your own in hypr/bindings.lua.
-- zero_default_bindings = false
--
-- Load Zero defaults.
require("default.hypr.zero")

-- Put your personal overrides in these files. They're loaded after Zero's
-- defaults so package updates can improve the defaults without rewriting your
-- ~/.config/hypr files.
require("hypr.monitors")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")

-- Toggle config flags dynamically.
require("default.hypr.toggles")

-- Add any other personal Hyprland configuration below.
-- o.window("qemu", { workspace = "5" })
