return {
	{ "niuiic/core.nvim" },
	{
		"niuiic/remote.nvim",
		config = function()
			local dir = "/home/lasim/sync/dotFiles/nvim/lua/config/"
			require("remote").setup({
				config_file = dir .. "remote.json",
				log_file = dir .. "remote.log",
				unmount = function(path)
					return "umount " .. path
				end,
				disconnect_on_leave = true,
				on_each_to_connect = function() end,
				on_each_connected = function() end,
				on_each_to_disconnect = function() end,
				on_each_disconnected = function() end,
			})
		end,
	},
}
