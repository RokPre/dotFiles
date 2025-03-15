return {
	"folke/snacks.nvim",
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
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "t", desc = "Temporary file", action = ":e ~/.tmp | silent %d" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "p", desc = "Project Explorer", action = "<cmd>ProjectExplorer<cr>" },
          { icon = " ", key = "d", desc = "Daily note", action = "<cmd>DiaryModeToggle<cr>" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
			},
		},
	},
}
