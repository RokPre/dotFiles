-- In your plugins configuration
return {
	{
		"yuratomo/w3m.vim",
		config = function()
			-- Ensure w3m binary is available
			if vim.fn.executable("w3m") == 1 then
				-- Configure w3m-related settings
				vim.g.w3m_command = "/usr/bin/w3m"
			else
				print("w3m binary not found")
			end
		end,
	},
}
