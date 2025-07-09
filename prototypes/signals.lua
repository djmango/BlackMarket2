-- GUI scale multiplier from mod settings
local gui_scale = settings.global["BM2-gui_scale"].value

data:extend(
	{
		{
			type = "item-subgroup",
			name = "virtual-signal-market",
			group = "signals",
			order = "y[virtual-signal-market]"
		},
		
		{
			type = "virtual-signal",
			name = "signal-market-auto-all",
			icon = "__BlackMarket2__/graphics/signal-market-auto-all.png",
			icon_size = math.floor(32 * gui_scale),
			subgroup = "virtual-signal-market",
			order = "y[market]-aa"
		},
		{
			type = "virtual-signal",
			name = "signal-market-auto-sell",
			icon = "__BlackMarket2__/graphics/signal-market-auto-sell.png",
			icon_size = math.floor(32 * gui_scale),
			subgroup = "virtual-signal-market",
			order = "y[market]-ab"
		},
		{
			type = "virtual-signal",
			name = "signal-market-auto-buy",
			icon = "__BlackMarket2__/graphics/signal-market-auto-buy.png",
			icon_size = math.floor(32 * gui_scale),
			subgroup = "virtual-signal-market",
			order = "y[market]-ac"
		},


	}
)
