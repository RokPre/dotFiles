local builtin = require('telescope.builtin')

return {
	"folke/snacks.nvim",
	priority = 1000,
	opts = {
		dashboard = {
			preset = {
				--         header = [[
				--       ::::    ::: :::::::::: ::::::::  :::     ::: :::::::::::   :::   :::
				--      :+:+:   :+: :+:       :+:    :+: :+:     :+:     :+:      :+:+: :+:+:
				--     :+:+:+  +:+ +:+       +:+    +:+ +:+     +:+     +:+     +:+ +:+:+ +:+
				--    +#+ +:+ +#+ +#++:++#  +#+    +:+ +#+     +:+     +#+     +#+  +:+  +#+
				--   +#+  +#+#+# +#+       +#+    +#+  +#+   +#+      +#+     +#+       +#+
				--  #+#   #+#+# #+#       #+#    #+#   #+#+#+#       #+#     #+#       #+#
				-- ###    #### ########## ########      ###     ########### ###       ###
				--  ]],
				header = [[
    _   __            _    __ _          
   / | / /___   ____ | |  / /(_)____ ___ 
  /  |/ // _ \ / __ \| | / // // __ `__ \
 / /|  //  __// /_/ /| |/ // // / / / / /
/_/ |_/ \___/ \____/ |___//_//_/ /_/ /_/ 
]],
        -- stylua: ignore
        ---@type snacks.dashboard.Item[]
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = builtin.find_files },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = builtin.live_grep },
          { icon = " ", key = "p", desc = "Project Explorer", action = "<cmd>ProjectManager<cr>" },
          { icon = " ", key = "d", desc = "Daily note", action = "<cmd>FloatingDiary<cr>" },
          { icon = " ", key = "c", desc = "Config", action = function() builtin.find_files({cwd = vim.fn.stdpath('config')}) end },
          { icon = " ", key = "s", desc = "Restore Session", action = "<Cmd>ListSession<cr>" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
			},
		},
		image = {
			enabled = false,
			doc = {
				enabled = true,
				inline = true,
			},
		},
	},
}
