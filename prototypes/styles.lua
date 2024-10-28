data:extend(
	{
		--------------------------------------------------------------------------------------
		{
			type = "font",
			name = "font_blkmkt",
			from = "default",
			border = false,
			size = 15
		},
		{
			type = "font",
			name = "font_bold_blkmkt",
			from = "default-bold",
			border = false,
			size = 15
		},
		
		--------------------------------------------------------------------------------------
		{
			type = "sprite",
			name = "sprite_main_blkmkt",
			filename = "__BlackMarket2__/graphics/but-main.png",
			width = 30,
			height = 30,
		},
		{
			type = "sprite",
			name = "sprite_energy_blkmkt",
			filename = "__BlackMarket2__/graphics/energy.png",
			width = 32,
			height = 32,
		},
	}
)		

--------------------------------------------------------------------------------------
local default_gui = data.raw["gui-style"].default

default_gui.frame_blkmkt_style = 
{
	type="frame_style",
	parent="frame",
	top_padding = 0,
	right_padding = 0,
	bottom_padding = 0,
	left_padding = 0,
	resize_row_to_width = true,
	resize_to_row_height = false,
	-- max_on_row = 1,
}

default_gui.vertical_flow_blkmkt_style = 
{
	type = "vertical_flow_style",
	
	top_padding = 0,
	bottom_padding = 0,
	left_padding = 0,
	right_padding = 0,
	
	horizontal_spacing = 2,
	vertical_spacing = 2,
	resize_row_to_width = true,
	resize_to_row_height = false,
	max_on_row = 1,
	
	graphical_set = { type = "none" },
}

default_gui.horizontal_flow_blkmkt_style = 
{
	type = "horizontal_flow_style",
	
	top_padding = 0,
	bottom_padding = 0,
	left_padding = 0,
	right_padding = 0,
	
	horizontal_spacing = 2,
	vertical_spacing = 2,
	resize_row_to_width = true,
	resize_to_row_height = false,
	max_on_row = 1,
	
	graphical_set = { type = "none" },
}

default_gui.table_blkmkt_style =
{
	type = "table_style",
	horizontal_spacing = 5,
	vertical_spacing = 2,
	resize_row_to_width = true,
	resize_to_row_height = false,
	max_on_row = 1,
}

--------------------------------------------------------------------------------------
default_gui.label_blkmkt_style =
{
	type="label_style",
	parent="label",
	font="font_blkmkt",
	align = "left",
	default_font_color={r=1, g=1, b=1},
	hovered_font_color={r=1, g=1, b=1},
	top_padding = 1,
	right_padding = 1,
	bottom_padding = 0,
	left_padding = 1,
}

default_gui.label_bold_blkmkt_style =
{
	type="label_style",
	parent="label_blkmkt_style",
	font="font_bold_blkmkt",
	default_font_color={r=1, g=1, b=0.5},
	hovered_font_color={r=1, g=1, b=0.5},
}

default_gui.textfield_blkmkt_style =
{
    type = "textbox_style",
	font="font_bold_blkmkt",
	align = "left",
    font_color = {},
	default_font_color={r=1, g=1, b=1},
	hovered_font_color={r=1, g=1, b=1},
    selection_background_color= {r=0.66, g=0.7, b=0.83},
	top_padding = 0,
	bottom_padding = 0,
	left_padding = 1,
	right_padding = 1,
	minimal_width = 50,
	maximal_width = 200,
	graphical_set =
	{
		type = "composition",
		filename = "__core__/graphics/gui.png",
		priority = "extra-high-no-scale",
		corner_size = {3, 3},
		position = {16, 0}
	},
}    

default_gui.checkbox_blkmkt_style =
{
	type = "checkbox_style",
	parent="checkbox",
	font = "font_bold_blkmkt",
	font_color = {r=1, g=1, b=1},
	top_padding = 0,
	bottom_padding = 0,
	left_padding = 0,
	right_padding = 2,
	-- minimal_height = 32,
	-- maximal_height = 32,
}

default_gui.button_blkmkt_style = 
{
	type="button_style",
	parent="button",
	font="font_bold_blkmkt",
	align = "center",
	default_font_color={r=1, g=1, b=1},
	hovered_font_color={r=1, g=1, b=1},
	top_padding = 0,
	right_padding = 0,
	bottom_padding = 0,
	left_padding = 0,
	left_click_sound =
	{
		{
		  filename = "__core__/sound/gui-click.ogg",
		  volume = 1
		}
	},
}

default_gui.dropdown_blkmkt_style = 
{
	type="dropdown_style",
	parent="dropdown",
	font="font_bold_blkmkt",
	align = "center",
	default_font_color={r=1, g=1, b=1},
	hovered_font_color={r=1, g=1, b=1},
	top_padding = 0,
	right_padding = 0,
	bottom_padding = 0,
	left_padding = 0,
	left_click_sound =
	{
		{
		  filename = "__core__/sound/gui-click.ogg",
		  volume = 1
		}
	},
}

default_gui.button_blkmkt_credits_style = 
{
	type="button_style",
	parent="button",
	font="font_bold_blkmkt",
	align = "center",
	default_font_color={r=1, g=1, b=1},
	hovered_font_color={r=1, g=1, b=1},
	top_padding = 0,
	right_padding = 0,
	bottom_padding = 0,
	left_padding = 0,
	height = 36,
	scalable = false,
	left_click_sound =
	{
		{
		  filename = "__core__/sound/gui-click.ogg",
		  volume = 1
		}
	},
}

--------------------------------------------------------------------------------------
default_gui.sprite_main_blkmkt_style = 
{
	type="button_style",
	parent="button",
	top_padding = 0,
	right_padding = 0,
	bottom_padding = 0,
	left_padding = 0,
	height = 36,
	width = 36,
	scalable = false,
}

default_gui.sprite_group_blkmkt_style = 
{
	type="button_style",
	parent="button",
	top_padding = 0,
	right_padding = 0,
	bottom_padding = 0,
	left_padding = 0,
	width = 64,
	height = 64,
	scalable = false
}

default_gui.sprite_obj_blkmkt_style = 
{
	type="button_style",
	parent="button",
	top_padding = 0,
	right_padding = 0,
	bottom_padding = 0,
	left_padding = 0,
	height = 32,
	width = 32,
	-- minimal_width = 32,
	-- minimal_height = 32,
	scalable = false
}
