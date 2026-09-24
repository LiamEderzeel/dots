local M = {}

function M.next_monitor()
	local pip = hl.get_window("title:^Picture-in-Picture$")
	if not pip then
		return
	end

	-- monitors ordered left to right, pick the one after the PiP's current monitor
	local mons = hl.get_monitors()
	table.sort(mons, function(a, b)
		return a.x < b.x
	end)

	local idx = 1
	for i, m in ipairs(mons) do
		if m.id == pip.monitor.id then
			idx = i % #mons + 1
			break
		end
	end
	local target = mons[idx]

	local prev = hl.get_active_window()
	local sel = "address:" .. pip.address

	hl.dispatch(hl.dsp.focus({ window = sel }))
	hl.dispatch(hl.dsp.window.move({ monitor = target.name }))

	local mw = target.width / target.scale
	local mh = target.height / target.scale

	local x = target.x + mw - pip.size.x - 8
	local y
	if idx % 2 == 0 then
		y = target.y + 6 + 36 -- even: top-right
	else
		y = target.y + mh - pip.size.y - 8 -- odd: bottom-right
	end

	hl.dispatch(hl.dsp.window.move({ x = math.floor(x), y = math.floor(y) }))

	-- return focus to whatever was focused before
	if prev and prev.address ~= pip.address then
		hl.dispatch(hl.dsp.focus({ window = "address:" .. prev.address }))
	end
end

return M
