return {
  "ve5li/better-goto-file.nvim",
  config = true,
  ---@module "better-goto-file"
  ---@type better-goto-file.Options
  keys = {
    { "gf", mode = { "n" }, function() require("better-goto-file").goto_file() end, silent = true, desc = "Better go to file under cursor" },
  }
}
