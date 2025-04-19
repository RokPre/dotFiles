-- TODO: Add a print snippet. If a variable/code it highlighted it will put it in a print statement.
local lines = {
	"#! /usr/bin/python3",
	"",
	"def init():",
	"    pass",
	"",
	"",
	"def main():",
	"    pass",
	"",
	"",
	"def exception():",
	"    pass",
	"",
	"",
	"def finalize():",
	"    pass",
	"",
	"",
	'if __name__ == "__main__":',
	"    try:",
	"        init()",
	"        main()",
	"    except:",
	"        exception()",
	"    finally:",
	"        finalize()",
}

vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "main.py",
	nested = true,
	callback = function()
		local is_empty = vim.fn.line("$") == 1 and vim.fn.getline(1) == ""
		if is_empty then
			vim.api.nvim_buf_set_lines(0, 0, 0, false, lines)
		end
	end,
})
