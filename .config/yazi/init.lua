-- Update Kitty tab title with Yazi's current directory
local cached_title = ""
local old_cwd = Header.cwd

Header.cwd = function(self)
	local cwd = tostring(cx.active.current.cwd)
	local name = cwd:match("([^/]+)$") or cwd
	local home = os.getenv("HOME") or ""
	if cwd == home or cwd == home .. "/" then
		name = "~"
	end
	if name ~= cached_title then
		cached_title = name
		Command("bash"):arg(home .. "/.config/kitty/scripts/set-tab-title.sh"):arg(name):spawn()
	end
	return old_cwd(self)
end
