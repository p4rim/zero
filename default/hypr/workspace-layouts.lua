-- Restore workspace layouts saved by zero-hyprland-workspace-layout-toggle.

local paths = require("default.hypr.paths")
local require_all = require("default.hypr.require_all")

local layouts_dir = paths.state_home .. "/zero/workspace-layouts"

require_all.files(layouts_dir, "zero.workspace-layouts", { reload = true })
